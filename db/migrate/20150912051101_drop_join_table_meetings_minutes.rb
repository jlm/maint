class DropJoinTableMeetingsMinutes < ActiveRecord::Migration[4.2]
  def change
  	drop_join_table :meetings, :minutes
  end
end
