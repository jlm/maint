class AddAbbrevToTaskGroups < ActiveRecord::Migration
  def change
    add_column :task_groups, :abbrev, :string
  end
end
