json.array!(@task_groups) do |task_group|
  json.extract! task_group, :id, :name, :vice_chair_id, :chair_id
  json.url task_group_url(task_group, format: :json)
end
