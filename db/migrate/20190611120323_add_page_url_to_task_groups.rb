class AddPageUrlToTaskGroups < ActiveRecord::Migration
  def change
    add_column :task_groups, :page_url, :string
  end
end
