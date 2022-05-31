if @request
  json.extract! @request, :id, :date, :standard, :clauseno, :clausetitle, :rationale, :proposal, :impact, :name,
    :email, :company
end
json.url item_request_url(@item, @request, format: :json) if @request
