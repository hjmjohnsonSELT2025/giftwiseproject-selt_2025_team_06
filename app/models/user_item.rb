class UserItem < ApplicationRecord
  belongs_to :user
  belongs_to :item

  validates :category, inclusion: { in: ["like", "dislike"] }
end
