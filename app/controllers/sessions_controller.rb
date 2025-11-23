class SessionsController < ApplicationController
  def new

  end

  # We will create a session everytime we log in
  def create
    # Finding the user by the username entered
    user = User.find_by(username: params[:username])

    # if a user exists and they are authenticated, we create our session
    if user.nil?
      # If there is no user found from the email, we stay on login page
      flash[:alert] = "Username doesn't exist"
      redirect_to login_path
    elsif user && user.authenticate(params[:password])
      session[:user_id] = user.id
      # Quick notice welcoming back the user
      flash[:notice] = "Welcome back, #{user.username}!"
      # Redirect to our home page
      redirect_to events_path
    else
      # If there is an incorrect password, we stay on login page
      flash[:alert] = "Incorrect password"
      redirect_to login_path
    end
  end

  # We will destroy our session everytime we log out of our account
  def destroy
    # Remove the session assigned to the user and flash the notice
    session.delete(:user_id)
    flash[:notice] = "You have logged out successfully."
    redirect_to login_path, notice: "Logged out successfully"
  end
end
