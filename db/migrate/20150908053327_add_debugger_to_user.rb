class AddDebuggerToUser < ActiveRecord::Migration
  def change
    add_column :users, :debugger, :boolean, default: false
  end
end
