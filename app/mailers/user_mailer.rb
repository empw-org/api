class UserMailer < ApplicationMailer
  def welcome_email(user_id)
    @user = User.find(user_id)
    mail(to: email_with_name(@user), subject: suffix_subject('Welcome'))
  end

  def contact_us_email(contact_us_id)
    @contact_us = ContactUs.find(contact_us_id)
    puts 'Sending email to '
    p email_with_name(@contact_us)
    mail(to: email_with_name(@contact_us), subject: suffix_subject('We got it'))
  end
end
