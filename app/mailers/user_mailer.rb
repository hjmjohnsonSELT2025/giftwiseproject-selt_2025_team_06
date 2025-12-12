class UserMailer < ApplicationMailer
  default from: "group6@giftwise.com"

  def password_changed(user)
    @user = user
    mail(to: @user.email, subject: "Your password has been updated")
  end
end