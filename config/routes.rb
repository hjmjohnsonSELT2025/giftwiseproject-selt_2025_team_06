Rails.application.routes.draw do
  get 'user_items/index'
  get 'user_items/create'
  get 'user_items/destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :user_items, only: [:index, :create, :destroy]
  get "/preferences", to: "user_items#index", as: :preferences

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
end
