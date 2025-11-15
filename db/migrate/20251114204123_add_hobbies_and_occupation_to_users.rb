class AddHobbiesAndOccupationToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :hobbies, :string
    add_column :users, :occupation, :string
  end
end
