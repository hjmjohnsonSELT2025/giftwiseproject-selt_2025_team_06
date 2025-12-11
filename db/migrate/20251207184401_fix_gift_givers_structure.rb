class FixGiftGiversStructure < ActiveRecord::Migration[7.1]
  def change
    # Remove giver_id if present
    if column_exists?(:gift_givers, :giver_id)
      remove_column :gift_givers, :giver_id
    end

    # Remove old JSON recipients column if present
    if column_exists?(:gift_givers, :recipients)
      remove_column :gift_givers, :recipients
    end

    # Add recipient_id if missing
    unless column_exists?(:gift_givers, :recipient_id)
      add_column :gift_givers, :recipient_id, :integer
    end

    # Add gift_id if missing
    unless column_exists?(:gift_givers, :gift_id)
      add_column :gift_givers, :gift_id, :integer
    end

    # Foreign keys — only add if missing
    unless foreign_key_exists?(:gift_givers, :events)
      add_foreign_key :gift_givers, :events, column: :event_id
    end

    unless foreign_key_exists?(:gift_givers, :users)
      add_foreign_key :gift_givers, :users, column: :user_id   # giver
    end

    unless foreign_key_exists?(:gift_givers, column: :recipient_id)
      add_foreign_key :gift_givers, :users, column: :recipient_id
    end

    unless foreign_key_exists?(:gift_givers, :gifts)
      add_foreign_key :gift_givers, :gifts, column: :gift_id
    end
  end
end
