class AddIndexToItems < ActiveRecord::Migration
  def change
  	add_index :items, :minuteable_id
  	add_index :meetings, :minuteable_id
  end
end
