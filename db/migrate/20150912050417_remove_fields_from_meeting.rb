class RemoveFieldsFromMeeting < ActiveRecord::Migration
  def change
    remove_column :meetings, :minuteable_id, :integer
    remove_column :meetings, :minuteable_type, :string
  end
end
