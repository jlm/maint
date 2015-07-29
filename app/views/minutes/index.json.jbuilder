json.array!(@minutes) do |minute|
  json.extract! minute, :id, :date, :text, :status
  json.url minute_url(minute, format: :json)
end
