# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user request.params[:token]
      logger.add_tags 'ActionCable', current_user.name, current_user.email
    end

    private

    def find_verified_user(token)
      decoded_token = JsonWebToken.decode(token)
      transporter = Transporter.find_by({ is_approved: true, id: decoded_token[:_id] })
      return transporter if transporter

      reject_unauthorized_connection
    end
  end
end
