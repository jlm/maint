class CreateTaskGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :task_groups do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
