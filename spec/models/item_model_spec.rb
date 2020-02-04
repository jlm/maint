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

    it 'allows a valid item to be created' do
      item.save
      expect(item).to be_valid
    end

    it 'prevents items with duplicate item numbers from being created' do
      item.save
      dupitem = FactoryBot.build(:item, subject: "Duplicate numbered item")
      dupitem.save
      dupitem.errors.full_messages.each { |e| puts e.inspect }
      puts "There are now #{Item.count} items in the database."
      expect(dupitem.errors[:number].size).to eq(1)
    end
  end
end