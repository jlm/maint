class CreateItems < ActiveRecord::Migration[4.2]
  def change
    create_table :items do |t|
      t.string :number
      t.date :date
      t.string :standard
      t.string :clause
      t.text :subject
      t.string :draft

      t.timestamps null: false
    end
  end
end
