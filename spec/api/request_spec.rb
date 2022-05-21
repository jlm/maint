require 'rails_helper'
require 'system/login_helper'
RSpec.configure do |config|
  config.include LoginHelper
end

RSpec.describe '/items/id/requests API', type: :request do
  let!(:my_item) { FactoryBot.create(:item) }
  let!(:my_request) { FactoryBot.build(:request) }

  before do
    log_in_as_admin
  end

  after do
    clean_up
  end

  describe '/items/id/request=' do
    it 'adds a request to an existing item' do
      post "/items/#{my_item.id}/requests", params: my_request, as: :json
      expect(jsonrsp['item_id']).to eql(my_item.id)
    end
  end
end
