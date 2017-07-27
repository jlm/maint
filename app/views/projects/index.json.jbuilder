json.array!(@projects) do |project|
  json.extract! project, :id, :task_group_id, :designation, :title, :short_title, :project_type, :status, :last_motion, :draft_no, :next_action, :par_url, :csd_url
  json.url project_url(project, format: :json)
end
