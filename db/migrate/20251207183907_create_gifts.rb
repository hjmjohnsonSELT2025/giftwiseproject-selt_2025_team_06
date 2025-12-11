class CreateGifts < ActiveRecord::Migration[7.1]
  def change
    create_table :gifts do |t|
      t.string  :name, null: false
      t.float   :price
      t.text    :purchase_url
      t.text    :description
      t.integer :upvotes, default: 0
      t.integer :status_id, null: false
      t.integer :creator_id, null: false

      t.timestamps
    end

    add_index :gifts, :status_id
    add_index :gifts, :creator_id

    add_foreign_key :gifts, :gift_statuses, column: :status_id
    add_foreign_key :gifts, :users, column: :creator_id
  end
end
