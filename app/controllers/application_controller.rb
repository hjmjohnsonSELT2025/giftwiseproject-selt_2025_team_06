class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access this page."
      redirect_to login_path
    end
  end
  # Use to track num of current friend requests used for ! icon
  before_action :set_friend_request_count, if: :current_user
  before_action :set_event_invite_count, if: :current_user

  def set_friend_request_count
    @pending_friend_requests_count = Friendship.where(friend_id: current_user.id, status: "pending").count
  end
  def set_event_invite_count
    @pending_event_invites_count =
      Invite.where(user_id: current_user.id, status: "pending").count
  end
end
