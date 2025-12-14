# This controller should be used also for account creation
class EventsController < ApplicationController
  # before_action :set_user, only: %i[ show edit update destroy ]
  before_action :require_login

  # GET /users or /users.json
  def index
    # Get
    created_ids = Event.where(user_id: current_user.id).select(:id)
    invited_ids = GiftGiver.where(user_id: current_user.id).select(:event_id)
    recipient_ids = Recipient.where(user_id: current_user.id).select(:event_id)

    if params[:created_by] == "me"
      # Events created by me
      @gift_giver_events = Event.where(user_id: current_user.id)

    elsif params[:created_by] == "not_me"
      # Events not created by me, but I was invited to
      @gift_giver_events = Event.where(id: invited_ids).where.not(user_id: current_user.id)

    else
      # created by me OR invited to ( ANYONE)
      @gift_giver_events = Event.where(id: created_ids).or(Event.where(id: invited_ids))
    end

    @gift_giver_events = @gift_giver_events.distinct # Else normal


    # Title search
    if params[:title].present?
      search = "%#{params[:title].strip.downcase}%"
      @gift_giver_events = @gift_giver_events.where("LOWER(title) LIKE ?", search)
    end

    # Filter by min/max budget
    if params[:min_budget].present?
      @gift_giver_events = @gift_giver_events.where("budget >= ?", params[:min_budget].to_f)
    end

    if params[:max_budget].present?
      @gift_giver_events = @gift_giver_events.where("budget <= ?", params[:max_budget].to_f)
    end

    # Sorting
    if params[:sort_by] == "name" && params[:direction] == "asc"
      @gift_giver_events = @gift_giver_events.order(title: :asc)

    elsif params[:sort_by] == "name" && params[:direction] == "desc"
      @gift_giver_events = @gift_giver_events.order(title: :desc)

    elsif params[:sort_by] == "date" && params[:direction] == "asc"
      @gift_giver_events = @gift_giver_events.order(event_date: :asc)

    elsif params[:sort_by] == "date" && params[:direction] == "desc"
      @gift_giver_events = @gift_giver_events.order(event_date: :desc)
    end

    @recipient_events = Event.where(id: recipient_ids).distinct

  end

  # GET /users/new
  def new

  end

  def show
    @event = Event.find(params[:id])

    accepted_ids = @event.invites.where(status: "accepted").pluck(:user_id)

    @friends_not_coming = current_user.all_friends.reject { |f| accepted_ids.include?(f.id) }
  end


  def invite
    @event = Event.find(params[:id])
    username = params[:username]

    user = User.find_by(username: username)
    if user.nil?
      flash[:alert] = "User not found"
      redirect_to event_path(@event) and return
    end

    invite = Invite.find_or_initialize_by(event_id: params[:id], user_id: user.id, status: "pending")

    if invite.persisted?
      flash[:alert] = "#{user.username} has already been invited"
    else
      invite.save!
      flash[:notice] = "You invited #{user.username} to #{@event.title}"
    end
    redirect_to event_path(@event)
  end

  def add_recipient
    @event = Event.find(params[:id])
    username = params[:username]
    user = User.find_by(username: username)
    if user.nil?
      flash[:alert] = "User not found"
      redirect_to event_path(@event) and return
    end
    recipient = Recipient.find_or_initialize_by(event_id: @event.id, user_id: user.id)
    if recipient.persisted?
      flash[:alert] = "That user is already a recipient in this event"
    else
      recipient.save!
      flash[:notice] = "Recipient added successfully"
    end

    redirect_to event_path(@event)
  end

  def add_event
    title = params["title"]
    event_date = params["event_date"]
    location = params["location"]
    budget = params["budget"]
    theme = params["theme"]

    if title.blank? || event_date.blank? || location.blank? || budget.blank? || theme.blank?
      flash[:alert] = "Please fill out all the fields"
      redirect_to new_event_path and return
    end
    @event = Event.new(title: title, event_date: event_date, location: location, budget: budget, theme: theme, user_id: session[:user_id])
    if @event.save
      GiftGiver.create!(event: @event, user_id: session[:user_id])
      flash[:notice] = "Event created successfully"
      redirect_to events_path
    else
      flash[:alert] = "Failed to create event"
      redirect_to new_event_path
    end
  end

  # Remove Attendee from event
  def remove_attendee
    @event = Event.find(params[:id])
    if @event.user_id != current_user.id
      flash[:alert] = "Only the Host can remove attendee's"
      redirect_to event_path(@event) and return
    end

    # Find invite FIRST
    invite = Invite.find_by(event_id: @event.id, user_id: params[:user_id])

    if invite.nil?
      flash[:alert] = "User is not attending this event"
      redirect_to event_path(@event) and return
    end

    # Now get attendee from the invite
    attendee = invite.user

    if attendee.nil?
      flash[:alert] = "User not found"
      redirect_to event_path(@event) and return
    end

    flash[:notice] = "You removed #{attendee.username} from #{@event.title}"
    invite.destroy
    redirect_to event_path(@event)
  end

  # invite a group of selected friends
  def invite_friends
    @event = Event.find(params[:id])
    friend_ids = params[:friend_ids] || []

    if friend_ids.empty?
      redirect_to event_path(@event), alert: "No friends selected"
      return
    end

    friend_ids.each do |friend_id|
      Invite.find_or_create_by!(
        event_id: @event.id,
        user_id: friend_id
      )
    end

    redirect_to event_path(@event), notice: "Invites sent!"
  end


end