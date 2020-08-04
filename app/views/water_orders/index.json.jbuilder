# frozen_string_literal: true

json.array! @water_orders do |water_order|
  json.call(water_order, :company)
  json.merge! water_order.attributes.except('company_id', 'user_id')

  if @authenticated_user.is_a?(Transporter) && water_order.state == WaterOrder::ASSIGNED_TO_TRANSPORTER
    json.call(water_order, user)
  end
end
