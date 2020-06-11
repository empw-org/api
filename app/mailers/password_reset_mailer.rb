class PasswordResetMailer < ApplicationMailer
  def password_reset_email(user_id, url)
    @user = User.find(user_id)
    @url = url
    mail(to: email_with_name(@user), subject: suffix_subject('Password Reset'))
  end
end
