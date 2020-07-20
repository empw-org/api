# frozen_string_literal: true

class CompaniesController < ApplicationController
  wrap_parameters :company, include: Company.attribute_names + [:password]
  skip_before_action :authenticate_request, only: %i[signup login]
  load_and_authorize_resource

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

  def login
    command = AuthenticateLogin.call(company_params, Company)
    company = command.result
    return render json: { company: company, token: TokenMaker.for(company) } if command.success? && company.is_approved

    render json: command.errors, status: :unauthorized
  end

  def index
    render json: Company.all
  end

  def approve
    company = Company.find(params[:id])
    render json: { message: 'company has been approved and can login' } if company&.update({ is_approved: true })
  end
end