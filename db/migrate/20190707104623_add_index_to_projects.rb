class AddIndexToProjects < ActiveRecord::Migration
  def change
    add_index :projects, :designation, unique: true
  end
end
