class RemoveMeetingIdFromMinutes < ActiveRecord::Migration
  def change
    remove_column :minutes, :meeting_id, :integer
  end
end
