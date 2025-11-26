class Event < ApplicationRecord
  belongs_to :user
  has_many :gift_givers, dependent: :destroy
end
