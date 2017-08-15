#json.extract! @project, :timeline_json
json.title { json.text {
  json.headline @project.par_url.nil? ? @project.short_title : link_to(@project.short_title, @project.par_url)
  json.text @project.title
} }
json.events @project.events.order(:date) do |event|
  caption = event.name + (event.description && !event.description.empty? ? ": #{event.description}" : '')
  json.media {
    json.url '<blockquote>' + @project.short_title + '</blockquote>'
    json.caption caption
  }
  json.start_date {
    json.day event.date.day.to_s
    json.month event.date.month.to_s
    json.year event.date.year.to_s
  }
  if event.end_date && event.date != event.end_date
    json.end_date {
      json.day event.end_date.day.to_s
      json.month event.end_date.month.to_s
      json.year event.end_date.year.to_s
    }
  end
  json.text {
    json.headline event.name
    json.text caption
  }
end
