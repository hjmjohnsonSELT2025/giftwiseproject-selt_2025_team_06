class AddHostIdToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :host_id, :integer
  end
end
