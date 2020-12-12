module ApplicationHelper
 def full_title(page_title)
  base_title = ENV["COMMITTEE"] + " Maintenance Database"
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

  def itemlink(num, id)
	link_to "#{num}", ENV["REQ_URL"] % id
  end

  def show_reqtxt(text)
    text
  end

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do 
              concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
              concat message 
            end)
    end
    nil
  end

  # Empty columns in Bootstrap layout are 'sometimes' not rendered as one would expect.  For instance when served
  # from localhost in development it looks fine, but served from my nginx-fronted server it doesn't.  I don't
  # get it.
  # This helper substitutes a non-breakable space for empty text.
  def maybe(text)
    text.present? ? text : '&nbsp;'.html_safe
  end

  # A static copy of the website can be created with the following command.  Some dynamic features don't
  # work in the static copy, including logging in, changing content and searching.  These features are
  # hidden by detecting the word "static" in the user-agent field sent by wget.
  # wget -P /path/to/destination/directory/ -mpck --user-agent="static" -e robots=off --wait 1 -E https://www.example.com/

  def staticreq
    request.env['HTTP_USER_AGENT'] =~ /static/
  end
end
