class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :username, null: false
      t.string :password_digest, null: false
      t.string :first_name, default: "", null: true
      t.string :last_name,  default: "", null: true
      t.text   :likes, default: "[]"
      t.text   :dislikes, default: "[]"
      t.date   :birthdate
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
  end
end