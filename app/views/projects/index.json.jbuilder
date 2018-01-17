json.array!(@projects) do |project|
  json.extract! project, :id, :task_group_id, :designation, :title, :short_title, :project_type, :status, :last_motion, :draft_no, :draft_url, :next_action, :award, :par_url, :csd_url, :files_url
  json.url task_group_project_url(project.task_group, project, format: :json)
end
