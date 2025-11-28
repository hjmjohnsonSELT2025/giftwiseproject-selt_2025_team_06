# Mailer used to send Account Recovery Options
class RecoveryMailer < ApplicationMailer
  default from: "group7@giftwise.com"  # Can be changed


  def reset_email(user)
    @user = user
    @token = @user.reset_token

    # http://localhost:3000/recovery/reset?token=XYZ
    @reset_url = recovery_reset_url(token: @token)

    mail(
      to: @user.email,
      subject: "Your GiftWise Password Reset Instructions"
    )
  end
end
