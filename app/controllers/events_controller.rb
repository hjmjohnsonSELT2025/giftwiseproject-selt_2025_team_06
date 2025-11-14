# This controller should be used also for account creation
class EventsController < ApplicationController
  # before_action :set_user, only: %i[ show edit update destroy ]
  # before_action :require_login

  # GET /users or /users.json
  def index

  end

  # GET /users/new
  def new

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
      flash[:notice] = "Event created successfully"
      redirect_to events_path
    else
      flash[:alert] = "Failed to create event"
      redirect_to new_event_path
    end
  end
end