class AddPageUrlToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :page_url, :string
  end
end
