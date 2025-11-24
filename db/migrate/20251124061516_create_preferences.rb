class CreatePreferences < ActiveRecord::Migration[7.1]
  def change
    create_table :preferences, primary_key: :preference_id do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index :preferences, :name, unique: true
  end
end