class AddMinutesUrlToMeetings < ActiveRecord::Migration[4.2]
  def change
    add_column :meetings, :minutes_url, :string
  end
end
