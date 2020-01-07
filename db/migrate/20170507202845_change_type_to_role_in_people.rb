class ChangeTypeToRoleInPeople < ActiveRecord::Migration[4.2]
  def change
    rename_column :people, :type, :role
  end
end
