Rails.application.routes.draw do
  resources :contact_us # TODO: add CSRF token
  resources :water_orders
  resources :sensors
  resources :consumption_reports

  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  scope '/admins' do
    post 'login', to: 'admins#login'
  end

  scope '/users' do
    post 'signup', to: 'users#signup'
    post 'login', to: 'users#login'
    patch 'verify', to: 'users#verify'
    get 'me', to: 'users#me'
    post 'reset-password', to: 'password_reset#reset_password'
    patch 'password', to: 'password_reset#change_password'
  end
end
