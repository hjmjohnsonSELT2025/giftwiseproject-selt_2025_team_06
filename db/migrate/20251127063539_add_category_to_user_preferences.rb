class AddCategoryToUserPreferences < ActiveRecord::Migration[7.1]
  def change
    add_column :user_preferences, :category, :string, null: false, default: "like"
  end
end