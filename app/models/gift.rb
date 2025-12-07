class Gift < ApplicationRecord
  belongs_to :gift_status, foreign_key: :status_id

  # A Gift may be linked to a giver/recipient pair through GiftGiver
  has_many :gift_givers
  has_many :givers, through: :gift_givers, source: :user
  has_many :recipients, through: :gift_givers, source: :recipient

  # Validations
  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :purchase_url, format: URI::regexp(%w[http https]), allow_nil: true
end
