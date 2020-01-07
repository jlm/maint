class AddAbbrevToTaskGroups < ActiveRecord::Migration[4.2]
  def change
    add_column :task_groups, :abbrev, :string
  end
end
