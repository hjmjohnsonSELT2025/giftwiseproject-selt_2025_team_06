# This controller is used for handling Account Recovery / Checks
class RecoveriesController < ApplicationController

  def new
  end

  def create
    identifier = params[:identifier].to_s.strip

    if identifier.blank?
      flash[:alert] = "Please enter your email or username."
      return redirect_to forgot_path
    end

    # Find User
    user = User.find_by(email: identifier) || User.find_by(username: identifier)

    # Do NOT reveal whether account exists always give message to not show what emails are associated with accounts (security)
    unless user
      flash[:notice] = "If this account exists, recovery instructions have been sent."
      return redirect_to login_path
    end

    # TODO
    # - password reset email
    # - username reminder email
    # - recovery instructions


    flash[:notice] = "If this account exists, recovery instructions have been sent."
    redirect_to login_path
  end
end
