class User < ApplicationRecord
  has_secure_password

  # 1-to-1 with user_information
  belongs_to :user_information, optional: true

  # Many-to-many via user_has_preferences join table
  has_many :user_has_preferences, dependent: :destroy
  has_many :preferences, through: :user_has_preferences

  # Events the user is hosting
  has_many :hosted_events,
           class_name: "Event",
           foreign_key: "host_id",
           dependent: :nullify

  # Gift-giver relationship (user → event)s
  has_many :gift_givers, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :gift_giver_events,
           through: :gift_givers,
           source: :event

  # Recipient relationship (user → event)
  has_many :recipients, dependent: :destroy
  has_many :received_events,
           through: :recipients,
           source: :event

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true
end
