class UserGiftStatus < ApplicationRecord
  belongs_to :user
  belongs_to :gift
  belongs_to :status, class_name: "GiftStatus"
end
