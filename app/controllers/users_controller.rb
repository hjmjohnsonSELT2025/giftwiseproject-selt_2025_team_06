# This controller should be used also for account creation
class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :require_login, except: [:index, :new, :create] # users should create accounts while NOT logged in

  # GET /users or /users.json
  def index

  end
  

  # GET /users/1 or /users/1.json
  def show
    @user = User.find(params[:id])
    if @user.nil?
      redirect_to users_path, alert: "User not found."
    end

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
    username   = params[:username]
    password   = params[:password]
    hobbies    = params[:hobbies]
    occupation = params[:occupation]
    email      = params[:email]
    birthdate  = params[:birthdate]

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

    # Check database uniqueness constraints
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

    # Create user -- occupation allowed to be nil
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
    redirect_to events_path
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
      params.require(:user).permit(
        :email,
        :username,
        :password,
        :first_name,
        :last_name,
        :user_information_id
      )
  end
end