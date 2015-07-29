json.array!(@imports) do |import|
  json.extract! import, :id, :filename, :imported
  json.url import_url(import, format: :json)
end
