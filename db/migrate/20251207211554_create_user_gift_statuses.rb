class CreateUserGiftStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :user_gift_statuses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :gift, null: false, foreign_key: true
      t.references :status, null: false, foreign_key: { to_table: :gift_statuses }

      t.timestamps
    end

    # Optional: prevent a user from assigning more than one status per gift
    add_index :user_gift_statuses, [:user_id, :gift_id], unique: true
  end
end
