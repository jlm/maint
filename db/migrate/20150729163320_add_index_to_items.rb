class AddIndexToItems < ActiveRecord::Migration[4.2]
  def change
    add_index :items, :minuteable_id
    add_index :meetings, :minuteable_id
  end
end
