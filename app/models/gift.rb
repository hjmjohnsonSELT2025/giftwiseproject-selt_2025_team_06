class Gift < ApplicationRecord
  belongs_to :status, class_name: "GiftStatus", foreign_key: :status_id
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"

  # Join table allowing users to assign status to this gift
  has_many :user_gift_statuses
  has_many :users, through: :user_gift_statuses
  has_many :statuses, through: :user_gift_statuses, source: :status
  has_many :created_gifts, class_name: "Gift", foreign_key: "creator_id"

  # A Gift may be linked to a giver/recipient pair through GiftGiver
  has_many :gift_givers
  has_many :givers, through: :gift_givers, source: :user
  has_many :recipients, through: :gift_givers, source: :recipient

  # Validations
  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :purchase_url, format: URI::regexp(%w[http https]), allow_nil: true
end
