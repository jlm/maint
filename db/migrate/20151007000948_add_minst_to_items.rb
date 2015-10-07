class AddMinstToItems < ActiveRecord::Migration
  def change
    add_column :items, :minst_id, :integer
  end
end
