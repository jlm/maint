class AddFilesUrlToProject < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :files_url, :string
  end
end
