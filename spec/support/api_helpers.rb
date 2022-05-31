module ApiHelpers
  def jsonrsp
    JSON.parse(response.body)
  end
end
