class AddMinuteableToItems < ActiveRecord::Migration
  def change
    add_column :items, :minuteable_id, :integer
    add_column :items, :minuteable_type, :string
  end
end
