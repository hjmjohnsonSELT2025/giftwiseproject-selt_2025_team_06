class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name

      t.timestamps
    end
    add_index :items, :name, unique: true
  end
end
