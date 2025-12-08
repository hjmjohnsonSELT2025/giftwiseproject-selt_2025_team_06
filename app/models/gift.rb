class Gift < ApplicationRecord
  belongs_to :status, class_name: "GiftStatus", foreign_key: :status_id
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"

  has_many :user_gift_statuses, dependent: :destroy
  has_many :users, through: :user_gift_statuses
  has_many :statuses, through: :user_gift_statuses, source: :status

  has_many :gift_givers, dependent: :destroy
  has_many :givers, through: :gift_givers, source: :user
  has_many :recipients, through: :gift_givers, source: :recipient

  has_many :user_gift_votes, dependent: :destroy
  def total_votes
    user_gift_votes.sum(:vote)
  end

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :purchase_url, format: URI.regexp(%w[http https]), allow_nil: true
end
