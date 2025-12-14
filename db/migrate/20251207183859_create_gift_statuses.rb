class CreateGiftStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :gift_statuses do |t|
      t.string :status_name
      t.timestamps
    end
  end
end
