class AddLatestStatusToItem < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :latest_status, :string
  end
end
