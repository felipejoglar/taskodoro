Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "landing#index"

  post "signup", to: "users#create"
  get "signup", to: "users#new"

  post "signin", to: "sessions#create"
  get "signin", to: "sessions#new"
  delete "signout", to: "sessions#destroy"

  get "forgot_password", to: "password_reset#new"
  post "password", to: "password_reset#create"
  get "password/edit", to: "password_reset#edit"
  patch "password", to: "password_reset#update"

  get ":user_id", to: "home#index", as: :home
end
