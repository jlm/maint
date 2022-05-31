require "rails_helper"
require "system/login_helper"

RSpec.configure do |config|
  config.include LoginHelper
end

RSpec.describe "Task Group system", type: :system do
  let!(:chair) { FactoryBot.create(:chair) }

  before do
    log_in_as_admin
  end

  after do
    clean_up
  end

  context "Given a chair" do
    it "enables me to create task groups" do
      visit "/task_groups"
      click_on "New Task Group"
      fill_in "Abbreviation", with: "TST"
      fill_in "Name", with: "Test"
      select chair.full_name, from: "Chair"
      click_on "Create Task group"

      expect(page).to have_text("Task Group successfully created")
    end
  end
end
