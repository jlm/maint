class RemoveFieldsFromMeeting < ActiveRecord::Migration[4.2]
  def change
    remove_column :meetings, :minuteable_id, :integer
    remove_column :meetings, :minuteable_type, :string
  end
end
