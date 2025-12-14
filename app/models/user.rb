class User < ApplicationRecord
  has_secure_password

  # 1-to-1 with user_information
  belongs_to :user_information, optional: true

  # Many-to-many via user_has_preferences join table
  has_many :user_preferences, dependent: :destroy
  has_many :preferences, through: :user_preferences

  # Events the user is hosting
  has_many :hosted_events,
           class_name: "Event",
           foreign_key: "user_id",
           dependent: :nullify

  # Gift-giver relationship (user → event)s
  has_many :gift_givers, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :gift_giver_events,
           through: :gift_givers,
           source: :event
  has_many :invites, dependent: :destroy
  has_many :invited_events, through: :invites, source: :event

  # Recipient relationship (user → event)
  has_many :recipients, dependent: :destroy
  has_many :recipient_events,
           through: :recipients,
           source: :event

  has_many :user_gift_statuses, dependent: :destroy
  has_many :gifts_with_status, through: :user_gift_statuses, source: :gift

  has_many :user_gift_votes, dependent: :destroy
  has_many :voted_gifts, through: :user_gift_votes, source: :gift

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create # only on create so not needed when updating pass (not required for updating reset_token)


  # Accepted friendships I initiated
  has_many :accepted_friendships,
           -> { where(status: "accepted") },
           class_name: "Friendship"

  has_many :friends,
           through: :accepted_friendships,
           source: :friend

  # Accepted friendships initiated by others
  has_many :inverse_accepted_friendships,
           -> { where(status: "accepted") },
           class_name: "Friendship",
           foreign_key: "friend_id"

  has_many :inverse_friends,
           through: :inverse_accepted_friendships,
           source: :user

  # Unified list of confirmed friends only
  def all_friends
    friends + inverse_friends
  end

end
