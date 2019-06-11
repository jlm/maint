json.name 'Active Ballots'
json.description "Active ballots for #{ENV['COMMITTEE']} at #{Date.today}"
json.options do
  json.table_head true
  json.table_foot false
  json.alternating_row_colors true
  json.row_hover true
  json.print_name true
  json.print_name_position 'above'
  json.print_description false
  json.print_description_position 'below'
  json.extra_css_classes ''
  json.use_datatables true
  json.datatables_sort true
  json.datatables_filter true
  json.datatables_paginate true
  json.datatables_lengthchange true
  json.datatables_paginate_entries 10
  json.datatables_info true
  json.datatables_scrollx false
  json.datatables_custom_commands '"order": [[ 0, \'desc\' ]], "columnDefs": [ { "type": "date", "targets": [ 3 ] } ]'
end
json.data do
  json.array! [ 1 ] do
    json.array! [ 'Project', 'Title', 'Ballot', 'End date' ]
  end

  json.array! @blt do |ballot|
    json.array! [ link_to(ballot[:project].designation, project_url(ballot[:project])),
                  link_to_unless(ballot[:project].page_url.nil?, ballot[:project].short_title, ballot[:project].page_url),
                  link_to_unless(ballot[:event].url.nil?, ballot[:event].name, ballot[:event].url),
                  ballot[:event].end_date
                ]
  end
end