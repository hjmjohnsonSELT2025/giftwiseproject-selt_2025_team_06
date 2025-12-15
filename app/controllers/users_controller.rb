# This controller should be used also for account creation
class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :require_login, except: [:index, :new, :create] # users should create accounts while NOT logged in

  # GET /users or /users.json
  def index

  end
  

  # GET /users/1 or /users/1.json
  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      redirect_to users_path, alert: "User not found."
    end
  end

  # GET /users/new
  def new
    @user = User.new
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
    redirect_to preferences_path
  end

  # GET /users/1 or /users/1.json
  def change_password
    @user = current_user
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update_password
    @user = current_user
    if @user.authenticate(params[:current_password])
      if params[:new_password] == params[:confirm_password]
        if @user.update(password: params[:new_password])
          flash[:success] = "Password updated successfully. An email confirmation was sent to your email!"
          UserMailer.password_changed(@user).deliver_later
          redirect_to @user
        else
          flash[:danger] = "Unable to update password. Please try again!"
          redirect_to change_password_path
        end
      else
        flash[:danger] = "New passwords don't match."
        redirect_to change_password_path
      end
    else
      flash[:danger] = "Current password is incorrect."
      redirect_to change_password_path
    end
  end
  # PATCH/PUT /users/1 or /users/1.json
  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Account updated successfully!"
    else
      flash[:alert] = "Account not updated!"
      redirect_to user_path(@user)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user = User.find(params[:id])

    if params[:confirm_username] == @user.username
      @user.destroy
      reset_session
      redirect_to login_path, notice: "User deleted successfully."
    else
      redirect_to @user, alert: "Username confirmation failed. Account not deleted."
    end
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
        :user_information_id,
        :occupation,
        :hobbies
      )
    end

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end