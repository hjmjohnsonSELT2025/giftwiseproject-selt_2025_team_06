class CreateUserGiftVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :user_gift_votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :gift, null: false, foreign_key: true
      t.integer :vote

      t.timestamps
    end

    add_index :user_gift_votes, [:user_id, :gift_id], unique: true
  end
end
