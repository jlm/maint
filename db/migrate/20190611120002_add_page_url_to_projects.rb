class AddPageUrlToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :page_url, :string
  end
end
