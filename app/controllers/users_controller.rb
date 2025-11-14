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
    username   = params[:username]
    password   = params[:password]
    hobbies    = params[:hobbies]
    occupation = params[:occupation]
    email      = params[:email]
    birthdate  = params[:birthdate]


    # Scenario: Username already taken
    if User.exists?(username: username)
      flash[:error] = "Username Taken"
      redirect_to new_user_path and return
    end

    # Scenario: Hobbies Missing
    if hobbies.blank?
      flash[:error] = "Hobbies Empty"
      redirect_to new_user_path and return
    end

    # Scenario: Occupation Missing (but allowed)
    if occupation.blank?
      user = User.create(username: username, password: password, hobbies: hobbies)
      session[:user_id] = user.id
      redirect_to root_path and return
    end

    # DOB Missing
    if birthdate.blank?
      flash[:error] = "DOB Empty"
      redirect_to new_user_path and return
    end

    # Normal successful creation
    user = User.create(
      email: email,
      username: username,
      password: password,
      birthdate: birthdate,
      hobbies: hobbies,
      occupation: occupation


    )

    session[:user_id] = user.id
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