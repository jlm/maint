class AddTaskGroupToPeople < ActiveRecord::Migration
  def change
    add_reference :people, :task_group, foreign_key: true
  end
end
