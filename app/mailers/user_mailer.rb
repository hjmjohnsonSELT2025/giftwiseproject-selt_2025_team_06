class UserMailer < ApplicationMailer
  def password_changed(user)
    @user = user
    # delegate to RecoveryMailer for reset link
    RecoveryMailer.reset_email(@user).deliver_later
    mail(to: @user.email, subject: "Your password has been updated")
  end
end