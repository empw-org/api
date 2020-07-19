# frozen_string_literal: true

module Mongoid
  module Document
    def as_json(options = {})
      attrs = super(options)
      attrs['_id'] = attrs['_id']['$oid']
      attrs
    end
  end
end
