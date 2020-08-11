# frozen_string_literal: true

Rails.application.routes.draw do
  resources :contact_us # TODO: add CSRF token
  resources :water_orders
  resources :sensors, only: %i[index create destroy]
  resources :consumption_data
  resources :consumption_reports
  resources :transporters, only: %i[index destroy]
  resource :transporter
  resources :companies, only: %i[index destroy]
  resource :company
  resource :user

  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  mount ActionCable.server => '/cable'

  scope '/water_orders' do
    patch ':id/ready_for_shipping', to: 'water_orders#mark_as_ready_for_shipping'
    patch ':id/claim', to: 'water_orders#claim'
    patch ':id/pick', to: 'water_orders#pick'
    patch ':id/deliver', to: 'water_orders#deliver'
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

  scope '/transporter' do
    get 'current_water_order', to: 'transporters#current_water_order'
    get 'statistics', to: 'transporters#statistics'
    patch 'image', to: 'transporters#update_image'
  end

  scope '/users' do
    post 'signup', to: 'users#signup'
    post 'login', to: 'users#login'
    patch 'verify', to: 'users#verify'
    post 'reset-password', to: 'password_reset#reset_password'
    patch 'password', to: 'password_reset#change_password'
  end
end
