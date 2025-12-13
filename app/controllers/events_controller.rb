# This controller should be used also for account creation
class EventsController < ApplicationController
  # before_action :set_user, only: %i[ show edit update destroy ]
  # before_action :require_login
  MAX_TOTAL_GIFTS = 5
  MAX_WISHLIST_GIFTS = 3

  # GET /users or /users.json
  def index
    # Get
    created_ids = Event.where(user_id: current_user.id).select(:id)
    invited_ids = GiftGiver.where(user_id: current_user.id).select(:event_id)

    if params[:created_by] == "me"
      # Events created by me
      @events = Event.where(user_id: current_user.id)

    elsif params[:created_by] == "not_me"
      # Events not created by me, but I was invited to
      @events = Event.where(id: invited_ids).where.not(user_id: current_user.id)

    else
      # created by me OR invited to ( ANYONE)
      @events = Event.where(id: created_ids).or(Event.where(id: invited_ids))
    end

    @events = @events.distinct # Else normal


    # Title search
    if params[:title].present?
      search = "%#{params[:title].strip.downcase}%"
      @events = @events.where("LOWER(title) LIKE ?", search)
    end

    # Filter by min/max budget
    if params[:min_budget].present?
      @events = @events.where("budget >= ?", params[:min_budget].to_f)
    end

    if params[:max_budget].present?
      @events = @events.where("budget <= ?", params[:max_budget].to_f)
    end

    # Sorting
    if params[:sort_by] == "name" && params[:direction] == "asc"
      @events = @events.order(title: :asc)

    elsif params[:sort_by] == "name" && params[:direction] == "desc"
      @events = @events.order(title: :desc)

    elsif params[:sort_by] == "date" && params[:direction] == "asc"
      @events = @events.order(event_date: :asc)

    elsif params[:sort_by] == "date" && params[:direction] == "desc"
      @events = @events.order(event_date: :desc)
    end

  end

  # GET /users/new
  def new

  end

  def show
    @event = Event.find(params[:id])

    # Accepted attendees via invites table
    @accepted_invites = @event.invites.where(status: "accepted").includes(:user)

    # Gift givers and recipients from the event
    @gift_giver_entries = GiftGiver.where(event_id: @event.id)
    @recipients_for_current_user = @gift_giver_entries.where(user_id: current_user.id).includes(:recipient, :gift)
    @givers_for_current_user = @gift_giver_entries.where(recipient_id: current_user.id).includes(:user, :gift)
  end

  def assign_gift
    event = Event.find(params[:id])
    recipient_id = params[:recipient_id]
    gift_id = params[:gift_id]

    entry = GiftGiver.find_by(event_id: event.id,
                              user_id: current_user.id,
                              recipient_id: recipient_id)

    if entry.nil?
      flash[:alert] = "Gift assignment not found."
      redirect_to event_path(event) and return
    end

    entry.update(gift_id: gift_id)

    flash[:notice] = "Gift assigned successfully!"
    redirect_to event_path(event)
  end

  def remove_gift
    event = Event.find(params[:id])
    recipient_id = params[:recipient_id]

    entry = GiftGiver.find_by(event_id: event.id,
                              user_id: current_user.id,
                              recipient_id: recipient_id)

    if entry.nil?
      flash[:alert] = "Gift assignment not found."
    else
      entry.update(gift_id: nil)
      flash[:notice] = "Gift removed successfully."
    end

    redirect_to event_path(event)
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
      GiftGiver.create!(event: @event, user_id: session[:user_id], recipients: "[]")
      flash[:notice] = "Event created successfully"
      redirect_to events_path
    else
      flash[:alert] = "Failed to create event"
      redirect_to new_event_path
    end
  end

  def add
    @event = Event.find(params[:id])
    @selected_recipient = User.find(params[:recipient_id])

    # Based off of the budget and status of gifts
    budget = @event.budget.to_f
    wishlisted_status = GiftStatus.find_by(status_name: "Wishlisted")
    wishlisted_ids = Gift.joins(:user_gift_statuses).where(user_gift_statuses: { user_id: @selected_recipient.id, status_id: wishlisted_status&.id }).pluck(:id)
    ignored_status    = GiftStatus.find_by(status_name: "Ignore")
    ignored_ids = Gift.joins(:user_gift_statuses).where(user_gift_statuses: { user_id: @selected_recipient.id, status_id: ignored_status&.id }).pluck(:id)

    # Generating our suggestions based on the preferences
    @wishlist_gifts = Gift.joins(:user_gift_statuses).where(user_gift_statuses: { user_id: @selected_recipient.id, status_id: wishlisted_status&.id }).where("price <= ?", budget).limit(MAX_WISHLIST_GIFTS)
    @general_suggestions = Gift.where("price <= ?", budget).where.not(id: ignored_ids).where.not(id: wishlisted_ids).limit(MAX_TOTAL_GIFTS)
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
end