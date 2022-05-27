require 'rails_helper'
require 'system/login_helper'
RSpec.configure do |config|
  config.include LoginHelper
end

RSpec.describe '/items API', type: :request do
  let!(:my_item) { FactoryBot.create(:item) }

  describe '/items?search=' do
    let(:item) { jsonrsp.first }

    before do
      get "/items", params: { search: my_item.number }, headers: { "ACCEPT" => "application/json" }
    end

    it 'Get returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'comprises an array of items containing one element' do
      expect(jsonrsp.length).to eql(1)
    end

    it 'has an item number' do
      expect(item).to include('number')
    end

    it 'has the correct item number' do
      expect(item['number']).to eql(my_item.number)
    end
  end

  describe '/items/id' do
    let(:item) { jsonrsp }

    before do
      get "/items", params: { search: my_item.number }, headers: { "ACCEPT" => "application/json" }
      get "/items/#{jsonrsp.first['id']}", headers: { "ACCEPT" => "application/json" }
      puts item.inspect
    end

    it 'Get returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'comprises a hash of elements' do
      expect(jsonrsp).to be_a(Hash)
    end

    it 'has an item number' do
      expect(item).to include('number')
    end

    it 'has the correct item number' do
      expect(item['number']).to eql(my_item.number)
    end
  end

  describe '/items=' do
    let!(:my_new_item) { FactoryBot.build(:item) }
    context 'when unauthorized' do
      it 'refuses to create a new item' do
        post "/items", params: my_new_item, as: :json
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when authorized' do
      before do
        log_in_as_admin
      end
      after do
        clean_up
      end

      it 'creates a new item' do
        post "/items", params: my_new_item, as: :json
        expect(response).to have_http_status(:created)
      end
    end
  end

end
