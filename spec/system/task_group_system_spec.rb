require 'rails_helper'

RSpec.describe 'Task Group system', type: :system do
  let!(:chair) { FactoryBot.create(:chair) }

  before do
    # https://github.com/heartcombo/devise/wiki/How-To:-Test-with-Capybara
    u = User.create!(email: 'joe_tester@cuthberts.org', password: 'fishcakes')
    u.confirmed_at = Time.now
    u.admin = true
    u.save
    login_as(u, scope: :user)
  end

  after do
    # https://github.com/heartcombo/devise/wiki/How-To:-Test-with-Capybara
    Warden.test_reset!
  end

  it "enables me to create task groups" do
    visit '/task_groups'
    click_on 'New Task Group'
    fill_in "Abbreviation", with: "TST"
    fill_in "Name", with: "Test"
    select chair.full_name, from: 'Chair'
    click_on 'Create Task group'

    expect(page).to have_text("Task Group successfully created")
  end
end