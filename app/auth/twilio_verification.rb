# frozen_string_literal: true

require 'twilio-ruby'

# Verify phone_number using Twilio Verify API
class TwilioVerification
  account_sid = ENV['TWILIO_ACCOUNT_SID']
  auth_token = ENV['TWILIO_AUTH_TOKEN']
  service_sid = ENV['TWILIO_SERVICE_SID']
  @client = Twilio::REST::Client.new(account_sid, auth_token)
                                .verify.services(service_sid)

  class << self
    def send_code_to(phone_number)
      @client.verifications.create(to: phone_number, channel: 'sms').status
    end

    def correct_code?(phone_number, code)
      @client.verification_checks
             .create(to: phone_number, code: code)
             .status == 'approved'
    rescue Twilio::REST::RestError
      nil
    end
  end
end
