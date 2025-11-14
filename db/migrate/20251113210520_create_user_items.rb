class CreateUserItems < ActiveRecord::Migration[7.1]
  def change
    create_table :user_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.string :category

      t.timestamps
    end
  end
end
