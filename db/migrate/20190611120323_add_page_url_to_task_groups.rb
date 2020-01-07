class AddPageUrlToTaskGroups < ActiveRecord::Migration[4.2]
  def change
    add_column :task_groups, :page_url, :string
  end
end
