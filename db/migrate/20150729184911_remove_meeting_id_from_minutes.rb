class RemoveMeetingIdFromMinutes < ActiveRecord::Migration[4.2]
  def change
    remove_column :minutes, :meeting_id, :integer
  end
end
