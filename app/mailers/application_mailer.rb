# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'EMPW <empw.org@gmail.com>'
  layout 'mailer'

  def email_with_name(record)
    %("#{record.name}" <#{record.email}>)
  end

  def suffix_subject(subject)
    %(#{subject} - EMPW)
  end
end
