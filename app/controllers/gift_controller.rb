class GiftsController < ApplicationController
  before_action :set_gift_giver, only: [:new, :create]

  def new
    @gift = Gift.new
    @statuses = GiftStatus.all
  end

  def create
    @gift = Gift.new(gift_params)
    @statuses = GiftStatus.all

    if @gift.save
      # Attach this new gift to the giver/recipient/event via GiftGiver
      @gift_giver.update(gift_id: @gift.id)
      redirect_to recipient_path(@gift_giver.recipient_id), notice: "Gift idea added successfully!"
    else
      flash.now[:alert] = "Gift name is required" if @gift.errors[:name].present?
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_gift_giver
    @gift_giver = GiftGiver.find(params[:gift_giver_id])
  end

  def gift_params
    params.require(:gift).permit(:name, :price, :purchase_url, :status_id)
  end
end
