class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :status, presence: true
  validate :not_self

  def not_self
    errors.add(:friend, "Can't add yourself as a friend...") if user_id == friend_id
  end
end