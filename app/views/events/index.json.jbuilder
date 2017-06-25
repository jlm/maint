json.array!(@events) do |event|
  json.extract! event, :id, :name, :date, :description, :project
  json.url event_url(event, format: :json)
end
