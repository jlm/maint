json.array!(@events) do |event|
  json.extract! event, :id, :name, :date, :description
  json.url task_group_project_event_url(@task_group, @project, event, format: :json)
end
