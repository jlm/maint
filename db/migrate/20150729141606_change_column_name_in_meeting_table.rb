class ChangeColumnNameInMeetingTable < ActiveRecord::Migration
  def change
  	rename_column :meetings, :type, :meetingtype
  end
end
