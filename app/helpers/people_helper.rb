module PeopleHelper
  def sti_person_path(role = "person", person = nil, action = nil)
    send "#{format_sti(action, role, person)}_path", person
  end

  def format_sti(action, role, person)
    action || person ? "#{format_action(action)}#{role.underscore}" : "#{role.underscore.pluralize}"
  end

  def format_action(action)
    action ? "#{action}_" : ""
  end
end
