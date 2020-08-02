class VerificationMessageJob < ApplicationJob
  queue_as :verification_messages

  def perform(phone_number)
    TwilioVerification.send_code_to(phone_number)
  end
end
