# This controller should be used also for account creation
class EventsController < ApplicationController
  # before_action :set_user, only: %i[ show edit update destroy ]
  # before_action :require_login
  MAX_TOTAL_GIFTS = 5
  MAX_WISHLIST_GIFTS = 3
  before_action :require_login

  # GET /users or /users.json
  def index
    created_ids   = Event.where(user_id: current_user.id).select(:id)
    invited_ids   = GiftGiver.where(user_id: current_user.id).select(:event_id)
    recipient_ids = GiftGiver.where(recipient_id: current_user.id).select(:event_id)
    base_scope = Event.all

    if params[:title].present?
      search = "%#{params[:title].strip.downcase}%"
      base_scope = base_scope.where("LOWER(title) LIKE ?", search)
    end

    if params[:min_budget].present?
      base_scope = base_scope.where("budget >= ?", params[:min_budget].to_f)
    end

    if params[:max_budget].present?
      base_scope = base_scope.where("budget <= ?", params[:max_budget].to_f)
    end

    if params[:sort_by] == "name"
      base_scope = base_scope.order(title: params[:direction] == "desc" ? :desc : :asc)
    elsif params[:sort_by] == "date"
      base_scope = base_scope.order(event_date: params[:direction] == "desc" ? :desc : :asc)
    end

    @gift_giver_events =
      if params[:created_by] == "me"
        base_scope.where(user_id: current_user.id)
      elsif params[:created_by] == "not_me"
        base_scope.where(id: invited_ids).where.not(user_id: current_user.id)
      else
        base_scope.where(id: created_ids).or(base_scope.where(id: invited_ids))
      end.distinct

    @recipient_events =
      base_scope.where(id: recipient_ids).distinct
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
    @gift_assignments = GiftGiver.where(event_id: @event.id).includes(:user, :recipient, :gift).group_by(&:user)

    accepted_ids = @event.invites.where(status: "accepted").pluck(:user_id)
    @friends_not_coming = current_user.all_friends.reject { |f| accepted_ids.include?(f.id) }
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

    entry = GiftGiver.find_by(
      event_id: event.id,
      user_id: current_user.id,
      recipient_id: recipient_id
    )

    if entry.nil?
      flash[:alert] = "Gift assignment not found."
    else
      entry.update!(gift_id: nil)
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

    @event = Event.new(
      title: title,
      event_date: event_date,
      location: location,
      budget: budget,
      theme: theme,
      user_id: current_user.id,
      host_id: current_user.id
    )

    if @event.save
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

  def assign_roles
    @event = Event.find(params[:id])

    unless @event.user_id == current_user.id
      redirect_to event_path(@event), alert: "Only the host can assign roles"
      return
    end

    giver_id     = params[:giver_id].to_i
    recipient_id = params[:recipient_id].to_i

    if giver_id == recipient_id
      redirect_to event_path(@event), alert: "A user cannot gift themselves"
      return
    end

    unless Invite.exists?(event_id: @event.id, user_id: giver_id, status: "accepted") &&
           Invite.exists?(event_id: @event.id, user_id: recipient_id, status: "accepted")
      redirect_to event_path(@event), alert: "Both users must be attendees"
      return
    end

    if GiftGiver.exists?(
      event_id: @event.id,
      user_id: giver_id,
      recipient_id: recipient_id
    )
      redirect_to event_path(@event), alert: "This assignment already exists"
      return
    end

    Recipient.find_or_create_by!(
      event_id: @event.id,
      user_id: recipient_id
    )

    GiftGiver.create!(
      event_id: @event.id,
      user_id: giver_id,
      recipient_id: recipient_id
    )

    redirect_to event_path(@event), notice: "Recipient assigned"
  end


  def remove_assignment
    @event = Event.find(params[:id])

    unless current_user.id == @event.user_id
      redirect_to event_path(@event), alert: "Only the host can remove assignments"
      return
    end

    entry = GiftGiver.find_by(
      event_id: @event.id,
      user_id: params[:giver_id],
      recipient_id: params[:recipient_id]
    )

    if entry
      entry.destroy
      redirect_to event_path(@event), notice: "Assignment removed"
    else
      redirect_to event_path(@event), alert: "Assignment not found"
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