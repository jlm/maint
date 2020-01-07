class AddIndexToProjects < ActiveRecord::Migration[4.2]
  def change
    add_index :projects, :designation, unique: true
  end
end
