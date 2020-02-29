Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'auth/register', to: 'users#register'
  post 'auth/login', to: 'users#login'
  post 'auth/verify', to: 'users#verify'
  get 'test', to: 'users#test'
end
