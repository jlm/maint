class AddContentTypeToImport < ActiveRecord::Migration[4.2]
  def change
    add_column :imports, :content_type, :string
  end
end
