require 'rails_helper'

RSpec.describe Item do
  let(:item) { FactoryBot.create(:item)}

  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  context 'when creating an Item' do
    it 'checks that the subject is not blank' do
      item.subject = ''
      item.save
      expect(item.errors[:subject].size).to eq(1)
    end

    it 'checks that the standard name has at least 3 characters' do
      item.standard = '45'
      item.save
      expect(item.errors[:standard].size).to eq(1)
    end
  end
end