class AddMeetingIdToMinutes < ActiveRecord::Migration[4.2]
  def change
    add_column :minutes, :meeting_id, :integer
  end
end
