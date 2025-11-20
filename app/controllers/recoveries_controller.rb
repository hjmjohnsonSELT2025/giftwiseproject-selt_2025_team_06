# This controller is used for handling Account Recovery / Checks
class RecoveriesController < ApplicationController

  def new
  end

  def create
    # Take what the user typed, turn it into a safe string, and clean up any spaces.
    identifier = params[:identifier].to_s.strip

    # Empty
    if identifier.blank?
      flash[:alert] = "Please enter your email or username."
      return redirect_to forgot_path
    end

    # Find User depedning on if they put either email OR username
    user = User.find_by(email: identifier) || User.find_by(username: identifier)

    # Dont reveal whether account exists always give message to not show what emails are associated with accounts (security)
    unless user
      flash[:notice] = "If this account exists, recovery instructions have been sent."
      return redirect_to login_path
    end

    # TODO EMAIL FORM
    # EMAIL SHOULD HAVE
    # Their Username
    # Password Reset Link(View)
    # Recovery instructions


    flash[:notice] = "If this account exists, recovery instructions have been sent."
    redirect_to login_path
  end
end
