# This controller should be used also for account creation
class EventsController < ApplicationController
  # before_action :set_user, only: %i[ show edit update destroy ]
  # before_action :require_login

  # GET /users or /users.json
  def index
    @events = current_user.gift_giver_events.distinct
    Rails.logger.debug "PARAMS => #{params.inspect}"

    # Search by event title
    if params[:title].present?
      @events = @events.where("LOWER(title) LIKE ?", "%#{params[:title].downcase}%")
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
      flash[:alert] = "User has already been invited"
    else
      invite.save!
      flash[:notice] = "Invitation sent"
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
end