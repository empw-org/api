# frozen_string_literal: true

class TransportersController < ApplicationController
  wrap_parameters :transporter, include: Transporter.attribute_names + %i[password car]
  before_action :set_transporter, only: :approve
  skip_before_action :authenticate_request, only: %i[login signup]
  load_and_authorize_resource

  def login
    command = AuthenticateLogin.call(transporter_params, Transporter)
    transporter = command.result
    if command.success?
      return render json: { transporter: transporter, token: TokenMaker.for(transporter) } if transporter.is_approved

      command.errors.add(:message, 'Your account was not approved yet')
    end

    render json: command.errors, status: :unauthorized
  end

  def signup
    transporter = Transporter.new(transporter_params)
    if transporter.save
      render json: {
        message: 'Registered Successfully. An admin will review your data then you can login.'
      }
      TransporterMailer.signup_email(transporter.id.to_s).deliver_later
    else
      render json: transporter.errors, status: :unprocessable_entity
    end
  end

  def approve
    return render json: { message: 'Already approved' } if @transporter.is_approved

    if @transporter.update({ is_approved: true })
      render json: { message: 'Transporter has been approved and can login' }
    end
    TransporterMailer.approve_email(transporter.id.to_s).deliver_later
  end

  # GET /transporters
  def index
    @transporters = Transporter.all

    render json: @transporters
  end

  # GET /transporter
  def show
    render json: @authenticated_user
  end

  # PATCH/PUT /transporter
  def update
    return render json: @authenticated_user if @authenticated_user.update(transporter_params)

    render json: @authenticated_user.errors, status: :unprocessable_entity
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transporter
    @transporter = Transporter.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def transporter_params
    params.require(:transporter).permit(:name, :phone_number, :email,
                                        :password, :address, :ssn, car: %i[model type])
  end
end
