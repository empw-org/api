# frozen_string_literal: true

class ContactUsController < ApplicationController
  before_action :set_contact_us, only: %i[show destroy]
  skip_before_action :authenticate_request, only: :create
  load_and_authorize_resource

  # GET /contact_us
  def index
    @contact_us = ContactUs.all

    render json: @contact_us
  end

  # GET /contact_us/1
  def show
    render json: @contact_us
  end

  # POST /contact_us
  def create
    @contact_us = ContactUs.new(contact_us_params)
    if @contact_us.save
      render json: @contact_us, status: :created, location: @contact_us
      UserMailer.contact_us_email(@contact_us.id.to_s).deliver_later
    else
      render json: @contact_us.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contact_us/1
  def destroy
    @contact_us.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contact_us
    @contact_us = ContactUs.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def contact_us_params
    params.require(:contact_us).permit(:name, :email, :message, :from)
  end
end
