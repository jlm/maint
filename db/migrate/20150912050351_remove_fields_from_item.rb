class RemoveFieldsFromItem < ActiveRecord::Migration[4.2]
  def change
    remove_column :items, :minuteable_id, :integer
    remove_column :items, :minuteable_type, :string
  end
end
