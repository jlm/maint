json.array!(@projects) do |project|
  json.extract! project, :id, :task_group_id, :designation, :title, :short_title, :project_type, :status, :last_motion, :draft_no, :next_action, :pool_formed, :mec, :par_url, :csd_url, :par_approval, :par_expiry, :standard_approval, :published
  json.url project_url(project, format: :json)
end
