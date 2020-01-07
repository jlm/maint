class AddFieldsToMinute < ActiveRecord::Migration[4.2]
  def change
    add_reference :minutes, :item, index: true, foreign_key: true
    add_reference :minutes, :meeting, index: true, foreign_key: true
  end
end
