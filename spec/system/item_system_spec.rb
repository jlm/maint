require "rails_helper"
require "system/login_helper"

RSpec.configure do |config|
  config.include LoginHelper
end

RSpec.describe "Item system", type: :system do
  let!(:chair) { FactoryBot.create(:chair) }

  before do
    log_in_as_admin
    FactoryBot.create(:minst)
  end

  after do
    clean_up
    # Pointless comment
  end

  context "Given a chair" do
    it "enables me to create a new item" do
      visit "/items"
      click_on "New Item"
      fill_in "Number", with: "9999"
      fill_in "Standard", with: "802.1zz"
      fill_in "Clause", with: "1.2"
      fill_in "Subject", with: "A test item"
      click_button "Create Item"

      expect(page).to have_text("Item successfully created") # Item successfully created.
    end

    it "allows me to create a minute for an existing item" do
      myitem = FactoryBot.create(:item)
      mymeeting = FactoryBot.create(:meeting)
      visit "/items/#{myitem.id}"
      click_on "New Minute"
      #fill_in "Date", with: Date.today
      fill_in "Text", with: "This is the text of a minute."
      #fill_in "Status", with: "Published"
      click_button "Create Minute"

      expect(page).to have_text("Minute successfully created")
    end
  end
end
