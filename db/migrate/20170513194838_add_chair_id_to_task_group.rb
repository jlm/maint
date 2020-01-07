class AddChairIdToTaskGroup < ActiveRecord::Migration[4.2]
  def change
    add_belongs_to :task_groups, :chair, index: true
  end
end
