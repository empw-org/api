# frozen_string_literal: true

require 'twilio-ruby'

# Verify phone_number using Twilio Verify API
class TwilioVerification

  account_sid = ENV['TWILIO_ACCOUNT_SID']
  auth_token = ENV['TWILIO_AUTH_TOKEN']
  pp account_sid, auth_token
  @client = Twilio::REST::Client
            .new(account_sid, auth_token)
            .verify.services('VA0d0959f30e22dcee0e6ad5c84fea11ff')

  class << self

    def send_code_to(phone_number)
      @client.verifications.create(to: phone_number, channel: 'sms').status
    end

    def correct_code?(phone_number, code)
      @client.verification_checks
             .create(to: phone_number, code: code)
             .status == 'approved'
    end

  end
end
