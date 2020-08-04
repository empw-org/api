# frozen_string_literal: true

json.merge! water_order.attributes.except('company_id', 'user_id', 'transporter_id')
json.call(water_order, :company)

if @authenticated_user.is_a?(Transporter) && water_order.state == WaterOrder::ASSIGNED_TO_TRANSPORTER
  json.call(water_order, :user)
end
