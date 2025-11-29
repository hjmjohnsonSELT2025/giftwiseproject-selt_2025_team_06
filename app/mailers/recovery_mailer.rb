# app/mailers/recovery_mailer.rb
# Mailer for recovery Options
class RecoveryMailer < ApplicationMailer
  default from: "group6@giftwise.com"

  def reset_email(user)
    @user = user
    @token = @user.reset_token # get reset token

    @reset_url = recovery_reset_url(token: @token)

    mail(
      to: @user.email,
      subject: "Your GiftWise Password Reset Instructions"
    )
  end
end
