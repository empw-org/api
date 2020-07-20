class TransporterMailer < ApplicationMailer
  # frozen_string_literal: true

  def signup_email(transporter_id)
    @transporter = Transporter.find(transporter_id)
    mail(to: email_with_name(@transporter), subject: suffix_subject('Welcome'))
  end

  def approve_email(transporter_id)
    @transporter = Transporter.find(transporter_id)
    mail(to: email_with_name(@transporter), subject: suffix_subject('Welcome'))
  end
end
