class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :title
      t.date :event_date
      t.string :location
      t.decimal :budget, precision: 10, scale: 2
      t.string :theme
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
