class AddMinstToMinutes < ActiveRecord::Migration[4.2]
  def change
    add_column :minutes, :minst_id, :integer
  end
end
