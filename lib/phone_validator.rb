# frozen_string_literal: true

# Validates that the phone number is an Egyptian phone number
class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || 'is not valid') unless /\A01[0125][0-9]{8}\z/.match?(value)
  end
end
