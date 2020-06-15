# frozen_string_literal: true

# Validates location
# refer to https://docs.mongodb.com/manual/geospatial-queries/#geospatial-geojson
# Valid longitude values are between -180 and 180, both inclusive.
# Valid latitude values are between -90 and 90, both inclusive.
# Location uses https://github.com/mongoid/mongoid-geospatial/
class LocationValidator < ActiveModel::EachValidator
  def validate_each(record, _attribute, location)
    error_message = lambda { |name, min, max|
      "Valid #{name} values are between #{min} and #{max}, both inclusive"
    }
    errors = { lon: error_message.call('longitude', -180, 180),
               lat: error_message.call('latitude', -90, 90) }
    validator = { lon: ->(value) { value.between?(-180, 180) },
                  lat: ->(value) { value.between?(-90, 90) } }
    location.to_hsh(:lon, :lat).each do |key, value|
      record.errors.add(:location, errors[key]) unless validator[key].call(value)
    end
  end
end
