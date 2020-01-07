class AddMinuteableToItems < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :minuteable_id, :integer
    add_column :items, :minuteable_type, :string
  end
end
