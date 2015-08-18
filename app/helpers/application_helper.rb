module ApplicationHelper
 def full_title(page_title)
  base_title = "802.1 Maintenance Database"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
 end

  # From http://railscasts.com/episodes/228-sortable-table-columns?autoplay=true
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction, :open => params[:open], :closed => params[:closed]}, {:class => css_class}
  end

  def itemlink(num)
  	link_to "#{num}", "http://www.ieee802.org/1/files/public/maint/requests/maint_#{num}.pdf"
  end
end
