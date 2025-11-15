# This controller should be used also for account creation
class UsersController < ApplicationController
  #  before_action :set_movie, only: %i[ show edit update destroy ] --> commented out

  # GET /users or /users.json
  def index
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    Rails.logger.debug "===== CREATE USER DEBUG ====="
    Rails.logger.debug "Password received: #{params[:password].inspect}"
    Rails.logger.debug "Password length: #{params[:password]&.length}"

    username   = params[:username]
    password   = params[:password]
    hobbies    = params[:hobbies]
    occupation = params[:occupation]
    email      = params[:email]
    birthdate  = params[:birthdate]

    # STEP 1: Validate input format/presence FIRST
    # IF invalid password (blank or too short)
    if password.blank? || password.length < 6
      flash[:alert] = "Password Invalid"
      redirect_to new_user_path and return
    end

    # IF Birthdate Missing
    if birthdate.blank?
      flash[:alert] = "DOB Empty"
      redirect_to new_user_path and return
    end

    # IF Hobbies Missing
    if hobbies.blank?
      flash[:alert] = "Hobbies Empty"
      redirect_to new_user_path and return
    end

    # STEP 2: Check database uniqueness constraints
    # IF Username already taken should check before email
    if User.exists?(username: username)
      flash[:alert] = "Username Taken"
      redirect_to new_user_path and return
    end

    # IF Email already taken
    if User.exists?(email: email)
      flash[:alert] = "Email Taken"
      redirect_to new_user_path and return
    end

    # STEP 3: Create the user (occupation is optional)
    user = User.create!(
      email: email,
      username: username,
      password: password,
      birthdate: birthdate,
      hobbies: hobbies,
      occupation: occupation
    )

    session[:user_id] = user.id
    flash[:notice] = "Account created successfully!"
    redirect_to root_path
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :username, :password, :likes, :dislikes, :birthdate)
  end
end