class FixGiftGiverRecipientForeignKey < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:gift_givers, :recipient_id)
      add_column :gift_givers, :recipient_id, :bigint
    end
    if foreign_key_exists?(:gift_givers, :recipients)
      remove_foreign_key :gift_givers, :recipients
    end
    unless foreign_key_exists?(:gift_givers, :users, column: :recipient_id)
      add_foreign_key :gift_givers, :users, column: :recipient_id
    end
  end
end
