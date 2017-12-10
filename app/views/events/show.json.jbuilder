json.extract! @event, :id, :name, :date, :end_date, :description
json.url task_group_project_url(@task_group, @event.project)
