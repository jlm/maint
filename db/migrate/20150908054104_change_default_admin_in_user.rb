class ChangeDefaultAdminInUser < ActiveRecord::Migration[4.2]
  def change
    change_column_default :users, :admin, false
  end
end
