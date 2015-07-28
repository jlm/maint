class TestMailer < ActionMailer::Base

  def tagged_message
    mail(
      :subject => 'hello from TestMailer',
      :to      => 'johnlmessenger@gmail.com',
      :from    => 'maint@802-1.org',
      :tag     => 'my-tag',
      :track_opens => 'true'
    )
    print "Hello from tagged_message\n"

  end
end

