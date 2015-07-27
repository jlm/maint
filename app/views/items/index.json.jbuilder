json.array!(@items) do |item|
  json.extract! item, :id, :number, :date, :standard, :clause, :subject, :draft
  json.url item_url(item, format: :json)
end
