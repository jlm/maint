class ChangeColumnNameInMeetingTable < ActiveRecord::Migration[4.2]
  def change
  	rename_column :meetings, :type, :meetingtype
  end
end
