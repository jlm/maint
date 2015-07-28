class TempMailer < ActionMailer::Base #ApplicationMailer
  default from: "maint@802-1.org"

   def tagged_message
    mail(
      :subject => 'hello from TempMailer',
      :to      => 'johnlmessenger@gmail.com',
      :from    => 'maint@802-1.org',
      :tag     => 'my-tag',
      :track_opens => 'true'
    )
    print "Hello from tagged_message in TempMailer\n"

  end
   
end
