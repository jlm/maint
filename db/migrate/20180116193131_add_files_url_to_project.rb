class AddFilesUrlToProject < ActiveRecord::Migration
  def change
    add_column :projects, :files_url, :string
  end
end
