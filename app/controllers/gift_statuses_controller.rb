class GiftStatusesController < ApplicationController
  before_action :set_gift_status, only: [:show, :edit, :update, :destroy]

  # GET /gift_statuses
  def index
    @gift_statuses = GiftStatus.all
  end

  # GET /gift_statuses/:id
  def show
    @gifts = @gift_status.gifts  # all gifts belonging to this status
  end

  # GET /gift_statuses/new
  def new
    @gift_status = GiftStatus.new
  end

  # POST /gift_statuses
  def create
    @gift_status = GiftStatus.new(gift_status_params)

    if @gift_status.save
      redirect_to gift_statuses_path, notice: "Gift status created successfully!"
    else
      flash.now[:alert] = "Status name cannot be blank."
      render :new, status: :unprocessable_entity
    end
  end

  # GET /gift_statuses/:id/edit
  def edit
  end

  # PATCH/PUT /gift_statuses/:id
  def update
    if @gift_status.update(gift_status_params)
      redirect_to gift_status_path(@gift_status), notice: "Gift status updated successfully!"
    else
      flash.now[:alert] = "Status name cannot be blank."
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /gift_statuses/:id
  def destroy
    @gift_status.destroy
    redirect_to gift_statuses_path, notice: "Gift status deleted."
  end

  private

  def set_gift_status
    @gift_status = GiftStatus.find(params[:id])
  end

  def gift_status_params
    params.require(:gift_status).permit(:status_name)
  end
end
