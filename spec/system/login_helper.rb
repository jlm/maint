module LoginHelper
  def log_in_as_admin
    # https://github.com/heartcombo/devise/wiki/How-To:-Test-with-Capybara
    u = User.create!(email: "joe_tester@cuthberts.org", password: "fishcakes")
    u.confirmed_at = Time.now
    u.admin = true
    u.save
    login_as(u, scope: :user)
  end

  def clean_up
    # https://github.com/heartcombo/devise/wiki/How-To:-Test-with-Capybara
    Warden.test_reset!
  end
end
