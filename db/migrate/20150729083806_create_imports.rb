class CreateImports < ActiveRecord::Migration[4.2]
  def change
    create_table :imports do |t|
      t.string :filename
      t.boolean :imported

      t.timestamps null: false
    end
  end
end
