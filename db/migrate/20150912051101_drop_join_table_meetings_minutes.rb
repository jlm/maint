class DropJoinTableMeetingsMinutes < ActiveRecord::Migration
  def change
  	drop_join_table :meetings, :minutes
  end
end
