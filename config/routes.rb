Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # This will need to be our landing page!
  root "users#index"

  # Here then, are our routes across the site
  get  "/login",  to: "sessions#new"
  post "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"


  # Generate all the standard CRUD routes for users ()
  # resources :users

  # "Create Account" feature:
  # new_user_path  => GET  /users/new     (renders signup form)
  # users_path     => POST /users         (handles form submission)
  resources :users, only: [:new, :create]
end
