class AddGiftIdToGiftGivers < ActiveRecord::Migration[7.1]
  def change
    add_reference :gift_givers, :gift, foreign_key: true, if_not_exists: true
  end
end
