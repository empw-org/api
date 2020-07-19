# frozen_string_literal: true

class CompanyMailer < ApplicationMailer
  def signup_email(company_id)
    @company = Company.find(company_id)
    mail(to: email_with_name(@company), subject: suffix_subject('Welcome'))
  end

  def approve_email(company_id)
    @company = Company.find(company_id)
    mail(to: email_with_name(@company), subject: suffix_subject('Welcome'))
  end
end
