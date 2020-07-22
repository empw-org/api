# frozen_string_literal: true

class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless /\A01[0125][0-9]{8}\z/.match?(value)
      record.errors[attribute] << (options[:message] || 'is not valid')
    end
  end
end
