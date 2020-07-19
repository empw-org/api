# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  @correct_data = { ssn: 12_345_678_901_234, password: '123123123',
                    name: 'Johnny', email: 'a@b.com', phone_number: '+201207654321' }
end
