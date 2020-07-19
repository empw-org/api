# frozen_string_literal: true

module PasswordDigestRemover
  def as_json(options = {})
    attrs = super(options)
    attrs.delete('password_digest')
    attrs
  end
end
