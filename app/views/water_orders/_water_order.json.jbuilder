# frozen_string_literal: true

json.merge! water_order.attributes.except('company_id', 'user_id', 'transporter_id', '_id')
json.call(water_order, :company)
json._id water_order.id.to_s

if @authenticated_user.is_a?(Transporter) && water_order.state == WaterOrder::ASSIGNED_TO_TRANSPORTER
  json.call(water_order, :user)
end
