# This controller should be used also for account creation
class UsersController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

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
    @user = User.new(user_params)

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