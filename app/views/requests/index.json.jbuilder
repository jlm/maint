json.extract! @request, :id, :date, :standard, :clauseno, :clausetitle, :rationale, :proposal, :impact, :name, :email, :company
json.url item_request_url(@item, @request, format: :json)

