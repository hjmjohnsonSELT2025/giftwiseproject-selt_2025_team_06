# This controller is used for handling Account Recovery / Checks
class RecoveryController < ApplicationController

  def new
  end

  def create
    # Take what the user typed, turn it into a safe string, and clean up any spaces.
    identifier = params[:identifier].to_s.strip

    # Empty
    if identifier.blank?
      flash[:alert] = "Please enter your email or username."
      return redirect_to recovery_path
    end

    # Find User depending on if they put either email OR username
    user = User.find_by(email: identifier) || User.find_by(username: identifier)

    if user
      # Generate Token for User Password Reset
      token = SecureRandom.urlsafe_base64(32) # generate secure random token
      user.update(reset_token: token, reset_sent_at: Time.now) # Update users current token
    end

    # Send email
    #    RecoveryMailer.reset_email(user).deliver_now

    # Do NOT reveal whether account exists always give message to not show what emails are associated with accounts (security)
     flash[:notice] = "If this account exists, recovery instructions have been sent."
     redirect_to login_path
  end

  # -------
  # Handle setting a new password
  # -------
  def edit
    @token = params[:token] # Grab token & Find user
    @user = User.find_by(reset_token: @token)

    # IF NO USER FOUND || TOKEN INVALID || EXPIRED
    if @user.nil? || token_expired?(@user)
      flash[:alert] = "Invalid or expired recovery link."
      return redirect_to recovery_path
    end
    #If the token is valid -->  app/views/recovery/edit.html.erb
  end

  def update
    #  Find User & Read in token sent from form
    token = params[:token]
    @user = User.find_by(reset_token: token)

    # Invalid or Expired Token
    if @user.nil? || token_expired?(@user)
      flash[:alert] = "Invalid or expired recovery link."
      return redirect_to recovery_path
    end

    # Extract the new password from form
    new_password = params[:password]

    # Check Password Validity
    if new_password.blank? || new_password.size < 6
      flash[:alert] = "Invalid Password"
      return redirect_to recovery_reset_path(token: token) # Keep the user on the reset page --> save the token in the URL
    end


    # SUCCESS:  Update Users password and clear reset token so it cant be used more than once
    @user.update(password: new_password, reset_token: nil)
    flash[:notice] = "Password Successfully Updated! Please log in."
    redirect_to login_path
  end

  # Helper Method for determining Validity of Reset Token (15 Min until Invalid)
  private
  def token_expired?(user)
    user.reset_sent_at.nil?  ||  user.reset_sent_at < 15.minutes.ago
    end
end
