class FriendshipsController < ApplicationController
  before_action :require_login

  def index
    @friends = current_user.all_friends
    # Get any and all request (need to check both ways)
    @incoming_requests = Friendship.where(friend_id: current_user.id, status: "pending")
    @outgoing_requests = Friendship.where(user_id: current_user.id, status: "pending")
  end


  def create

    friend = User.find_by(username: params[:username])

    # 1. Validate user exists
    if friend.nil?
      redirect_to friendships_path, alert: "User not found" and return
    end

    # 2. Prevent self-friend
    if friend.id == current_user.id
      redirect_to friendships_path, alert: "Can't add yourself as a friend" and return
    end

    # 3. Prevent duplicates (in both directions)
    exists = Friendship.where(user_id: current_user.id, friend_id: friend.id).or(Friendship.where(user_id: friend.id, friend_id: current_user.id)).exists?

    if exists
      redirect_to friendships_path, alert: "Friend request already exists" and return
    end

    # 4. Create pending request
    Friendship.create!(
      user: current_user,
      friend: friend,
      status: "pending"
    )

    redirect_to friendships_path, notice: "Friend request sent"
  end


  def update
    friendship = Friendship.find(params[:id])

    # Only the receiver can accept
    unless friendship.friend_id == current_user.id
      redirect_to friendships_path, alert: "Not authorized" and return
    end

    friendship.update!(status: params[:status] || "accepted")

    redirect_to friendships_path, notice: "Friend request accepted"
  end

  def destroy
    friendship = Friendship.find(params[:id])

    # Either side can remove
    unless [friendship.user_id, friendship.friend_id].include?(current_user.id)
      redirect_to friendships_path, alert: "Not authorized" and return
    end

    friendship.destroy

    redirect_to friendships_path, notice: "Friend removed"
  end

end
