class Preference < ApplicationRecord
    has_many :user_preferences, dependent: :destroy
    has_many :users, through: :user_preferences
  
    validates :name, presence: true, uniqueness: true
  end