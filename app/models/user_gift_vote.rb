class UserGiftVote < ApplicationRecord
  belongs_to :user
  belongs_to :gift

  validates :vote, inclusion: { in: [-1, 1] }
  validates :user_id, uniqueness: { scope: :gift_id }
end
