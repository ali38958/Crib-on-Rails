class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset_email.subject
  #
  default from: ENV['GMAIL_USERNAME'] || 'no-reply@cribonrails.com'

  def password_reset_email(email, otp)
    @otp = otp
    mail(to: email, subject: 'Your Password Reset OTP - Crib on Rails')
  end
end
