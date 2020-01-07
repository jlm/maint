class CreateMinutes < ActiveRecord::Migration[4.2]
  def change
    create_table :minutes do |t|
      t.date :date
      t.text :text
      t.string :status

      t.timestamps null: false
    end
  end
end
