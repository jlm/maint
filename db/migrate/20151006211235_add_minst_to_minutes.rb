class AddMinstToMinutes < ActiveRecord::Migration
  def change
    add_column :minutes, :minst_id, :integer
  end
end
