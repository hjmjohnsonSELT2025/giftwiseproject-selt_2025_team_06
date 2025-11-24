class CreateUserPreferences < ActiveRecord::Migration[7.1]
  def change
    create_table :user_preferences do |t|
      t.references :user, null: false, foreign_key: true
      t.references :preference, null: false, foreign_key: true
      t.timestamps
    end
    
    add_index :user_preferences, [:user_id, :preference_id], unique: true
  end
end