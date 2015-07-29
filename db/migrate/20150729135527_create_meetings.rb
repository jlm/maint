class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.date :date
      t.string :type
      t.string :location
      t.integer :minuteable_id
      t.string :minuteable_type

      t.timestamps null: false
    end
  end
end
