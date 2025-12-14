class UserGiftStatusesController < ApplicationController
  before_action :require_login
  before_action :set_user_gift_status, only: [:edit, :update, :destroy]

  # GET /user_gift_statuses
  # Optional: showing all statuses assigned by current user
  def index
    @user_gift_statuses = current_user.user_gift_statuses.includes(:gift, :status)
  end

  # GET /user_gift_statuses/new?gift_id=#
  def new
    @gift = Gift.find(params[:gift_id])
    @statuses = GiftStatus.all
    @user_gift_status = UserGiftStatus.new
  end

  # POST /user_gift_statuses
  def create
    @user_gift_status = UserGiftStatus.new(user_gift_status_params)
    @user_gift_status.user = current_user  # force correct owner

    if @user_gift_status.save
      redirect_to gift_path(@user_gift_status.gift), notice: "Gift status assigned!"
    else
      @statuses = GiftStatus.all
      flash.now[:alert] = "Unable to assign status."
      render :new, status: :unprocessable_entity
    end
  end

  def toggle_wishlisted
    page = params[:page] || 1
    gift = Gift.find(params[:id])

    wishlisted_status = GiftStatus.find_by(status_name: "Wishlisted")
    default_status     = GiftStatus.find_by(status_name: "Default")

    if wishlisted_status.nil? || default_status.nil?
      return redirect_to gifts_path(page: page), alert: "Required statuses missing."
    end

    record = UserGiftStatus.find_or_initialize_by(
      user_id: current_user.id,
      gift_id: gift.id
    )

    if record.status_id == wishlisted_status.id
      record.status_id = default_status.id
      message = "#{gift.name} removed from wishlist."
    else
      record.status_id = wishlisted_status.id
      message = "#{gift.name} added to wishlist!"
    end

    record.save!
    redirect_to gifts_path(page: page), notice: message
  end

  def toggle_ignored
    page = params[:page] || 1
    gift = Gift.find(params[:id])
    ignored_status = GiftStatus.find_by(status_name: "Ignore")

    user_status = UserGiftStatus.find_or_initialize_by(
      user_id: current_user.id,
      gift_id: gift.id
    )

    if user_status.status_id == ignored_status&.id
      user_status.destroy
    else
      user_status.status_id = ignored_status.id
      user_status.save!
    end

    redirect_to gifts_path(page: page)
  end

  # GET /user_gift_statuses/:id/edit
  def edit
    @gift = @user_gift_status.gift
    @statuses = GiftStatus.all
  end

  # PATCH/PUT /user_gift_statuses/:id
  def update
    if @user_gift_status.update(user_gift_status_params)
      redirect_to gift_path(@user_gift_status.gift), notice: "Gift status updated!"
    else
      @statuses = GiftStatus.all
      flash.now[:alert] = "Unable to update status."
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /user_gift_statuses/:id
  def destroy
    gift = @user_gift_status.gift
    @user_gift_status.destroy
    redirect_to gift_path(gift), notice: "Gift status removed."
  end

  private

  def set_user_gift_status
    @user_gift_status = current_user.user_gift_statuses.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to user_gift_statuses_path, alert: "Not authorized to access this status."
  end

  def user_gift_status_params
    params.require(:user_gift_status).permit(:gift_id, :status_id)
  end
end
