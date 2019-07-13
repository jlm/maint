module ProjectsHelper
  def par_expiry_date(project)
    project&.events&.where(name: 'PAR Expiry')&.first&.date || ''
  end
end
