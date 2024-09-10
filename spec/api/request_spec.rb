require "rails_helper"
require "system/login_helper"
RSpec.configure do |config|
  config.include LoginHelper
end

RSpec.describe "/items/id/requests API", type: :request do
  before do
    log_in_as_admin
  end

  after do
    clean_up
  end

  describe "/items/id/request=" do
    let!(:my_item) { FactoryBot.create(:item) }
    let!(:my_request) { FactoryBot.build(:request) }
    it "adds a request to an existing item" do
      post "/items/#{my_item.id}/requests", params: my_request, as: :json
      expect(jsonrsp["item_id"]).to eql(my_item.id)
    end
  end

  describe "Delete /items/id/request" do
    let!(:myd_item) { FactoryBot.create(:item) }
    let!(:myd_request) { FactoryBot.create(:request, item_id: myd_item.id) }

    context "when deleting a non-existent request" do
      it "returns an HTTP Not Found status" do
        delete "/items/#{myd_item.id}/requests/98765", as: :json
        expect(response).to have_http_status(:not_found)
        #expect { delete "/items/#{myd_item.id}/requests/98765", as: :json }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it "deletes a request from an existing item" do
      delete "/items/#{myd_item.id}/requests/#{myd_request.id}", as: :json
      expect(response).to have_http_status(:success)
    end
  end
end
