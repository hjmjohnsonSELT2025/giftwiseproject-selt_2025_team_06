class UserItemsController < ApplicationController
  #
  # skip_before_action :require_login

  def index
    user = current_user || User.first || create_temp_user
    @user_items = user.user_items.includes(:item)
    @new_item = Item.new
  end

  def create
    item_name = params[:item_name].to_s.downcase.strip

    if item_name.blank?
      redirect_to preferences_path, alert: "Please enter an item."
      return
    end

    item = Item.find_or_create_by(name: item_name)

    # fallback user
    user = current_user || User.first || create_temp_user

    user_item = user.user_items.new(
      item: item,
      category: params[:category]
    )

    if user_item.save
      redirect_to preferences_path, notice: "Added to your #{params[:category]}s."
    else
      redirect_to preferences_path, alert: "Could not save the item."
    end
  end

  def destroy
    user = current_user || User.first || create_temp_user
    user_item = user.user_items.find(params[:id])
    user_item.destroy
    redirect_to preferences_path, notice: "Removed."
  end


  private

  # Automatically creates a fallback user so nothing breaks
  def create_temp_user
    User.create!(
      email: "temp@example.com",
      username: "tempuser",
      password: "password",
      first_name: "Temp",
      last_name: "User"
    )
  end
end