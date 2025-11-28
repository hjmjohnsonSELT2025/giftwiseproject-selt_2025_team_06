class Event < ApplicationRecord
  belongs_to :user
  has_many :gift_givers, dependent: :destroy
  has_many :invites, dependent: :destroy
  has_many :invited_users, through: :invites, source: :user
end
