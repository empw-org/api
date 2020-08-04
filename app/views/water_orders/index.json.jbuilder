# frozen_string_literal: true

json.array! @water_orders do |water_order|
  json.partial! water_order
end
