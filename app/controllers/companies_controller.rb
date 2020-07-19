# frozen_string_literal: true

class CompaniesController < ApplicationController
  wrap_parameters :company, include: Company.attribute_names + [:password]
  skip_before_action :authenticate_request, only: %i[signup login]

  def signup
    company = Company.new(company_params)
    if company.save
      render json: company
      CompanyMailer.signup_email(company.id.to_s).deliver_later
    else
      render json: company.errors, status: :unprocessable_entity
    end
  end

  def company_params
    params.require(:company).permit(:name, :phone_number, :email, :password, location: {})
  end

  def login; end
end
