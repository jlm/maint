class RemoveFieldsFromMinute < ActiveRecord::Migration[4.2]
  def change
    remove_column :minutes, :minuteable_id, :integer
    remove_column :minutes, :minuteable_type, :string
  end
end
