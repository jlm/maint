class AddBelongstoToTaskGroup < ActiveRecord::Migration[4.2]
  def change
    add_belongs_to :task_groups, :person, class: "Chair", index: true, foreign_key: true
  end
end
