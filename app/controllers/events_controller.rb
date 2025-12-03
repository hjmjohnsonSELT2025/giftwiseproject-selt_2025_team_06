# This controller should be used also for account creation
class EventsController < ApplicationController
  # before_action :set_user, only: %i[ show edit update destroy ]
  # before_action :require_login

  # GET /users or /users.json
  def index
    @events = current_user.gift_giver_events.distinct # .distinct makes sure theres no dupe events
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
    attendee = User.find_by(id: params[:user_id]) # Find attendee

    # Only the event owner (host) can remove attendees MAYBE Switch to non hosts just not being able to see the remove attendee button
    if @event.user_id != current_user.id
      flash[:alert] = "Only the Host can remove attendee's"
      redirect_to event_path(@event) and return
    end

    # User exists?
    if attendee.nil?
      flash[:alert] = "User not found"
    end

    invite = Invite.find_by(event_id: @event.id, user_id: attendee.id)

    # User going?
    if invite.nil?
      flash[:alert] = "User is not attending"
    else
      flash[:notice] = "You removed #{attendee.username} from #{@event.title}"
      invite.destroy
    end

    redirect_to event_path(@event)
  end

end