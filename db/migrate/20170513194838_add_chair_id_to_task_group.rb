class AddChairIdToTaskGroup < ActiveRecord::Migration
  def change
    add_belongs_to :task_groups, :chair, index: true
  end
end
