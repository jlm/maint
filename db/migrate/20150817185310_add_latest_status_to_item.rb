class AddLatestStatusToItem < ActiveRecord::Migration
  def change
    add_column :items, :latest_status, :string
  end
end
