require 'rails_helper'

RSpec.describe '/items API', type: :request do
  let!(:my_item) { FactoryBot.create(:item) }

  before do
  end

  after do
    # Do nothing
  end

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
      # get "/items/#{rsp['id']}", headers: { "ACCEPT" => "application/json" }
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
end
