class AddDebuggerToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :debugger, :boolean, default: false
  end
end
