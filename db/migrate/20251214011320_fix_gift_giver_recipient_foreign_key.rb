class FixGiftGiverRecipientForeignKey < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :gift_givers, :recipients
    add_foreign_key :gift_givers, :users, column: :recipient_id
  end
end
