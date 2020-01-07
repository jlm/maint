class CreateMeetingsMinutes < ActiveRecord::Migration[4.2]
  def change
    create_table :meetings_minutes, :id => false do |t|
    	t.references :meeting
    	t.references :minute
    end
    add_index :meetings_minutes, [ :meeting_id, :minute_id ]
    add_index :meetings_minutes, :minute_id
  end
end
