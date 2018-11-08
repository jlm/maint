class CreateMotions < ActiveRecord::Migration
  def change
    create_table :motions do |t|
      t.references :meeting, index: true, foreign_key: true
      t.references :project, index: true, foreign_key: true
      t.string :motion_text
      t.integer :number

      t.timestamps null: false
    end
  end
end
