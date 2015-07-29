class AddMeetingIdToMinutes < ActiveRecord::Migration
  def change
    add_column :minutes, :meeting_id, :integer
  end
end
