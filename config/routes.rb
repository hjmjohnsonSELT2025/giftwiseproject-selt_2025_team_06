Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # This will need to be our landing page!
  root "users#index"

  resources :users

  # Here then, are our routes across the site
  get  "/login",  to: "sessions#new"
  post "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get 'events', to: 'events#index', as: 'events'
  get 'events/new', to: 'events#new', as: 'new_event'
  post 'events/add_event', to: 'events#add_event', as: 'add_event_events'

  # Add Routes to Forgot View
  get  "/forgot", to: "recoveries#new",    as: :forgot
  post "/forgot", to: "recoveries#create"     # Handles Form Submission
end
