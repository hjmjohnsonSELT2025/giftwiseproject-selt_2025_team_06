class GiftsController < ApplicationController
  def index
    @gifts = Gift.all

    # VIEW FILTERS (reduce the dataset first)
    if params[:view].present?
      case params[:view]

      when "wishlisted"
        wishlisted = GiftStatus.find_by(status_name: "Wishlisted")
        @gifts = @gifts.joins(:user_gift_statuses)
                       .where(user_gift_statuses: {
                         user_id: current_user.id,
                         status_id: wishlisted.id
                       })

      when "ignore"
        ignored = GiftStatus.find_by(status_name: "Ignore")
        @gifts = @gifts.joins(:user_gift_statuses)
                       .where(user_gift_statuses: {
                         user_id: current_user.id,
                         status_id: ignored.id
                       })

      when "created"
        @gifts = @gifts.where(creator_id: current_user.id)
      end
    end

    # SEARCH FILTER (further reduce results)
    if params[:search].present?
      term = "%#{params[:search].downcase}%"
      @gifts = @gifts.where("LOWER(name) LIKE ?", term)
    end

    # SORTING (apply LAST so it sorts the filtered dataset)
    case params[:sort]
    when "name"  then @gifts = @gifts.order(:name)
    when "price" then @gifts = @gifts.order(:price)
    when "date"  then @gifts = @gifts.order(created_at: :desc)
    when "score" then @gifts = @gifts.order(upvotes: :desc) # TODO: Sort by upvotes not working as intended
    end


    # Status icons
    @wishlisted_status = GiftStatus.find_by(status_name: "Wishlisted")
    @ignored_status = GiftStatus.find_by(status_name: "Ignore")

    @user_statuses = UserGiftStatus
                       .where(user_id: current_user.id)
                       .pluck(:gift_id, :status_id)
                       .to_h
  end

  def increment_upvote
    gift = Gift.find(params[:id])
    gift.update(upvotes: gift.upvotes + 1)
    redirect_to gifts_path
  end

  def decrement_upvote
    gift = Gift.find(params[:id])
    gift.update(upvotes: [gift.upvotes - 1, 0].max)  # prevent negative votes
    redirect_to gifts_path
  end

  def upvote
    gift = Gift.find(params[:id])
    record = UserGiftVote.find_or_initialize_by(user: current_user, gift: gift)

    record.vote = 1  # upvote
    record.save

    redirect_to gifts_path
  end

  def downvote
    gift = Gift.find(params[:id])
    record = UserGiftVote.find_or_initialize_by(user: current_user, gift: gift)

    record.vote = -1  # downvote
    record.save

    redirect_to gifts_path
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

  def edit
    @gift = Gift.find(params[:id])

    if @gift.creator_id != current_user.id
      redirect_to gifts_path, alert: "You cannot edit someone else's gift."
    end
  end

  def update
    @gift = Gift.find(params[:id])

    if @gift.creator_id != current_user.id
      redirect_to gifts_path, alert: "You cannot update someone else's gift."
      return
    end

    if @gift.update(gift_params)
      redirect_to gifts_path, notice: "Gift updated successfully."
    else
      flash.now[:alert] = "Update failed."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @gift = Gift.find(params[:id])

    if @gift.creator_id != current_user.id
      redirect_to gifts_path, alert: "You cannot delete someone else's gift."
      return
    end

    @gift.destroy
    redirect_to gifts_path, notice: "Gift removed successfully."
  end

  def show
    @gift = Gift.find(params[:id])
  end

  private

  def gift_params
    params.require(:gift).permit(:name, :description, :price, :purchase_url, :upvotes, :status_id)
  end
end
