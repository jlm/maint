class ChangeTypeToRoleInPeople < ActiveRecord::Migration
  def change
    rename_column :people, :type, :role
  end
end
