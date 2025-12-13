# This controller should be used also for account creation
class EventsController < ApplicationController
  # before_action :set_user, only: %i[ show edit update destroy ]
  # before_action :require_login

  # GET /users or /users.json
  def index
    @gift_giver_events = current_user.gift_giver_events.distinct
    @recipient_events = current_user.recipient_events.distinct
  end

  # GET /users/new
  def new

  end

  def show
    @event = Event.find(params[:id])
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
      GiftGiver.create!(event: @event, user_id: session[:user_id], recipients: "[]")
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
end