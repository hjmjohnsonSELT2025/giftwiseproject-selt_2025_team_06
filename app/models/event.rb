class Event < ApplicationRecord
  belongs_to :host, foreign_key: "user_id", class_name: "User", optional: true
  has_many :gift_givers, dependent: :destroy
  has_many :invites, dependent: :destroy
  has_many :invited_users, through: :invites, source: :user
  has_many :recipients, dependent: :destroy
end
