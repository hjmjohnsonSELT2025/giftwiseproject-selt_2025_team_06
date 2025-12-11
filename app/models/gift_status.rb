class GiftStatus < ApplicationRecord
  # Regular association: default status for a gift
  has_many :gifts, foreign_key: :status_id

  # Join table association: user-specific statuses for gifts
  has_many :user_gift_statuses, foreign_key: :status_id
  has_many :users, through: :user_gift_statuses
  has_many :gifts_with_user_status, through: :user_gift_statuses, source: :gift
end
