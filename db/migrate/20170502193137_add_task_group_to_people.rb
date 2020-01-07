class AddTaskGroupToPeople < ActiveRecord::Migration[4.2]
  def change
    add_reference :people, :task_group, foreign_key: true
  end
end
