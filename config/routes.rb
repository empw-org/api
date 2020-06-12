Rails.application.routes.draw do
  resources :contact_us # TODO: add CSRF token
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/users' do
    post 'signup', to: 'users#signup'
    post 'login', to: 'users#login'
    patch 'verify', to: 'users#verify'
  end
  resources :water_order
end
