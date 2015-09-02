class AddContentTypeToImport < ActiveRecord::Migration
  def change
    add_column :imports, :content_type, :string
  end
end
