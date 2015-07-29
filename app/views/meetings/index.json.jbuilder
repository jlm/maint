json.array!(@meetings) do |meeting|
  json.extract! meeting, :id, :date, :meetingtype, :location, :minuteable_id, :minuteable_type
  json.url meeting_url(meeting, format: :json)
end
