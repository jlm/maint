require 'rails_helper'

RSpec.describe 'Task Group system', type: :system do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  it "enables me to create task groups" do
    visit '/task_groups'
    click_button "New Task Group"
    fill_in "Abbreviation", with: "TST"
    fill_in "Name", with: "Test"
    click_button 'Create Task group'

    expect(page).to have_text("Task group was successfully created.")
  end
end