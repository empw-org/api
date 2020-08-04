# frozen_string_literal: true

Rails.application.routes.draw do
  resources :contact_us # TODO: add CSRF token
  resources :water_orders
  resources :sensors
  resources :consumption_data
  resources :consumption_reports
  resources :transporters, only: :index
  resource :transporter
  resources :companies, only: :index
  resource :company
  resource :user

  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  mount ActionCable.server => '/cable'

  scope '/water_orders' do
    patch ':id/ready_for_shipping', to: 'water_orders#mark_as_ready_for_shipping'
    post 'destroy_all', to: 'water_orders#destroy_all'
  end

  scope '/admins' do
    post 'login', to: 'admins#login'
  end

  scope '/transporters' do
    post 'signup', to: 'transporters#signup'
    post 'login', to: 'transporters#login'
    patch ':id/approve', to: 'transporters#approve'
  end

  scope '/companies' do
    post 'signup', to: 'companies#signup'
    post 'login', to: 'companies#login'
    patch ':id/approve', to: 'companies#approve'
  end

  scope '/company' do
    get 'statistics', to: 'companies#statistics'
  end

  scope '/users' do
    post 'signup', to: 'users#signup'
    post 'login', to: 'users#login'
    patch 'verify', to: 'users#verify'
    post 'reset-password', to: 'password_reset#reset_password'
    patch 'password', to: 'password_reset#change_password'
  end
end
