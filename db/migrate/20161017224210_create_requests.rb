class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.text :reqtxt
      t.references :item, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
