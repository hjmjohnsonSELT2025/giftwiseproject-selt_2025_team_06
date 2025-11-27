class UserPreference < ApplicationRecord
    belongs_to :user
    belongs_to :preference

    validates :category, presence: true, inclusion: { in: ["like", "dislike"] }
    validates :user_id, uniqueness: { scope: [:preference_id, :category],
                                    message: "already selected for this category" }
  end