class FixGiftGiverRecipientForeignKey < ActiveRecord::Migration[7.1]
  def change
    if foreign_key_exists?(:gift_givers, :recipients)
      remove_foreign_key :gift_givers, :recipients
    end
    
    unless foreign_key_exists?(:gift_givers, :users, column: :recipient_id)
      add_foreign_key :gift_givers, :users, column: :recipient_id
    end
  end
end