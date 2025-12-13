class Recipient < ApplicationRecord
  belongs_to :event
  belongs_to :user
  has_many :gift_givers, dependent: :destroy
  validates :user_id, uniqueness: { scope: :event_id }
end
