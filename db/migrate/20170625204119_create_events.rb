class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.string :name
      t.date :date
      t.string :description
      t.references :project, index: true, foreign_key: true
    end
  end
end
