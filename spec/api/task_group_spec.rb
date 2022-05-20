require 'rails_helper'

RSpec.describe 'TaskGroup', type: :request do
  let!(:my_tg) { FactoryBot.create(:task_group) }

  before do
    get '/task_groups', headers: { "ACCEPT" => "application/json" }
  end

  after do
    # Do nothing
  end

  context 'when Getting TaskGroup index in JSON' do
    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    context 'contains the required JSON elements: ' do
      it 'includes the abbreviation' do
        expect(jsonrsp.first).to include('abbrev')
      end
      it 'includes the page URL' do
        jsonrsp.each do |rsp|
          next unless rsp['abbrev'] == my_tg.abbrev
          get "/task_groups/#{rsp['id']}", headers: { "ACCEPT" => "application/json" }
          expect(jsonrsp).to include('page_url')
          expect(jsonrsp['page_url']).to eq(my_tg.page_url)
        end
      end
    end
  end
end


