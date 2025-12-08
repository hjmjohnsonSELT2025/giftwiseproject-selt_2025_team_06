class GiftsController < ApplicationController
  def index
    @gifts = Gift.all

    # Sorting
    case params[:sort]
    when "name"  then @gifts = @gifts.order(:name)
    when "price" then @gifts = @gifts.order(:price)
    when "date"  then @gifts = @gifts.order(created_at: :desc)
    end

    # Viewing
    if params[:view].present?
      case params[:view]
      when "wishlisted"
        wishlisted_status = GiftStatus.find_by(status_name: "Wishlisted")
        @gifts = @gifts.joins(:user_gift_statuses)
                       .where(user_gift_statuses: {
                         user_id: current_user.id,
                         status_id: wishlisted_status.id
                       })
      when "ignore"
        ignore_status = GiftStatus.find_by(status_name: "Ignore")
        @gifts = @gifts.joins(:user_gift_statuses)
                       .where(user_gift_statuses: {
                         user_id: current_user.id,
                         status_id: ignore_status.id
                       })
      end
    end

    # Searching
    if params[:search].present?
      term = "%#{params[:search].downcase}%"
      @gifts = @gifts.where("LOWER(name) LIKE ?", term)
    end

    @wishlisted_status = GiftStatus.find_by(status_name: "Wishlisted")
    @ignored_status = GiftStatus.find_by(status_name: "Ignore")
    @user_statuses = UserGiftStatus.where(user_id: current_user.id).pluck(:gift_id, :status_id).to_h
  end


  def new
    @gift = Gift.new
    @statuses = GiftStatus.all
  end

  def create
    @gift = Gift.new(gift_params)

    default_status = GiftStatus.find_by(status_name: "Default")
    @gift.status_id = default_status.id
    @gift.creator_id = current_user.id

    if @gift.save
      redirect_to gifts_path, notice: "Gift added successfully!"
    else
      flash.now[:alert] = "Gift name is required" if @gift.errors[:name].present?
      render :new, status: :unprocessable_entity
    end
  end

  private

  def gift_params
    params.require(:gift).permit(:name, :price, :purchase_url, :status_id)
  end
end
