class AddMinutesUrlToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :minutes_url, :string
  end
end
