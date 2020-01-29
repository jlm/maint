require 'rails_helper'

RSpec.describe 'People system', type: :system do
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

  it 'lets me create a Chair' do
    visit "/people/new"
    fill_in 'First name', with: 'Joe'
    fill_in 'Last name', with: 'Chairperson'
    fill_in 'Email', with: 'jchair@cuthberts.org'
    fill_in 'Affiliation', with: "Joe's Testers, Inc."
    select 'Chair', from: 'Role'
    click_on 'Create Person'

    expect(Person.count).to eql(1)
  end

 end