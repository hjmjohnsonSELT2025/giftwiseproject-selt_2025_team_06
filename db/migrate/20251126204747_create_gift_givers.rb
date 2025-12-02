class CreateGiftGivers < ActiveRecord::Migration[7.1]
  def change
    create_table :gift_givers do |t|
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :recipients, default: "[]"

      t.timestamps
    end
  end
end
