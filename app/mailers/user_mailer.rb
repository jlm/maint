# JLM 150728 This came from http://stackoverflow.com/questions/5679571/how-can-i-customize-devise-to-send-password-reset-emails-using-postmark-mailer

class UserMailer < ActionMailer::Base
  include Devise::Mailers::Helpers

  default from: "maint@802-1.org"

  def confirmation_instructions(record, token, opts={})
    #binding.pry
    devise_mail(record, :confirmation_instructions, opts)
  end

  def reset_password_instructions(record, token, opts={})
    devise_mail(record, :reset_password_instructions, opts)
  end

  def unlock_instructions(record, token, opts={})
    devise_mail(record, :unlock_instructions, opts)
  end

  # you can then put any of your own methods here
end