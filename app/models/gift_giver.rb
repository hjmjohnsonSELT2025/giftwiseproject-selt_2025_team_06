class GiftGiver < ApplicationRecord
  belongs_to :event
  belongs_to :user
  belongs_to :recipient, class_name: "User", optional: true
  belongs_to :gift, optional: true
end
