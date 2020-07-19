# frozen_string_literal: true

class CompaniesController < ApplicationController
  wrap_parameters :company, include: Company.attribute_names + [:password]
  skip_before_action :authenticate_request, only: [:signup, :login]

  def signup
    data = company_params
    company = Company.new(data)
    if company.save
      render json: company
    else
      render json: company.errors, status: :unprocessable_entity
    end
  end

  def company_params
    params.require(:company).permit(:name, :phone_number, :email, :password, location: {})
  end

end
