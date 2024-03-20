Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "landing#index"

  resource :signup, only: %i[ create new ], controller: "users"
  resource :signin, only: %i[ create new ], controller: "sessions"
  resource :signout, only: :destroy, controller: "sessions"

  resource :forgot_password, only: :new, controller: "passwords"
  resource :password, only: %i[ create update edit ], controller: "passwords"

  scope ":user_id", constraints: { user_id: /\d+/ } do
    get "/", to: "projects#index", as: :home

    resources :projects
  end
end
