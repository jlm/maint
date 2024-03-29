json.extract! @task_group, :id, :abbrev, :name, :chair_id, :page_url, :created_at, :updated_at
json.projects @task_group.projects do |project|
  json.extract! project, :short_title
  json.url task_group_project_url(@task_group, project, format: :json)
end
# json.projects @task_group.projects, :short_title, :draft_no, :last_motion, :status, :next_action
