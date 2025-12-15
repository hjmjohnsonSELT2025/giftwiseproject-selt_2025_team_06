class GiftsController < ApplicationController
  def index
    @gifts = Gift.all
    direction = params[:direction] == "asc" ? :asc : :desc

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

    case params[:sort]
    when "name"
      @gifts = @gifts.order(name: direction, id: :asc)
    when "price"
      @gifts = @gifts.order(price: direction, id: :asc)
    when "date"
      @gifts = @gifts.order(created_at: direction, id: :asc)
    when "upvotes"
      @gifts = @gifts.order(upvotes: direction, id: :asc)
    else
      @gifts = @gifts.order(created_at: :desc, id: :asc)
    end

    # Limit the # of gifts to view per page
    @per_page = 16
    @page     = (params[:page] || 1).to_i
    @total_pages = (@gifts.count / @per_page.to_f).ceil
    @gifts = @gifts.offset((@page - 1) * @per_page).limit(@per_page)

    # Status icons
    @wishlisted_status = GiftStatus.find_by(status_name: "Wishlisted")
    @ignored_status = GiftStatus.find_by(status_name: "Ignore")

    @user_statuses = UserGiftStatus
                       .where(user_id: current_user.id)
                       .pluck(:gift_id, :status_id)
                       .to_h
  end

  def upvote
    gift = Gift.find(params[:id])
    vote_record = UserGiftVote.find_or_initialize_by(user: current_user, gift: gift)

    old_vote = vote_record.vote || 0
    new_vote = nil

    if old_vote == 1
      # Clicking upvote again removes the vote
      new_vote = 0
      vote_record.destroy
    else
      # Either no vote or a downvote → set to +1
      new_vote = 1
      vote_record.vote = 1
      vote_record.save!
    end

    delta = new_vote - old_vote
    gift.update!(upvotes: gift.upvotes + delta)

    redirect_to gifts_path(request.query_parameters)
  end

  def downvote
    gift = Gift.find(params[:id])
    vote_record = UserGiftVote.find_or_initialize_by(user: current_user, gift: gift)

    old_vote = vote_record.vote || 0
    new_vote = nil

    if old_vote == -1
      # Clicking downvote again removes the vote
      new_vote = 0
      vote_record.destroy
    else
      # Either no vote or an upvote → set to -1
      new_vote = -1
      vote_record.vote = -1
      vote_record.save!
    end

    delta = new_vote - old_vote
    gift.update!(upvotes: gift.upvotes + delta)

    redirect_to gifts_path(request.query_parameters)
  end

  def new
    @gift = Gift.new
    @statuses = GiftStatus.all
    @event_id = params[:event_id]
    @recipient_id = params[:recipient_id]
  end

  def create
    @gift = Gift.new(gift_params)

    default_status = GiftStatus.find_by(status_name: "Default")
    @gift.status_id = default_status.id
    @gift.creator_id = current_user.id

    event_id     = params[:event_id]
    recipient_id = params[:recipient_id]

    if @gift.save
      if event_id.present? && recipient_id.present?
        entry = GiftGiver.find_by(
          event_id: event_id,
          user_id: current_user.id,
          recipient_id: recipient_id
        )

        if entry
          entry.update!(gift_id: @gift.id)
        end

        redirect_to event_path(event_id, recipient_id: recipient_id),
                    notice: "Gift added and assigned successfully!"
      else
        redirect_to gifts_path, notice: "Gift added successfully!"
      end
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
