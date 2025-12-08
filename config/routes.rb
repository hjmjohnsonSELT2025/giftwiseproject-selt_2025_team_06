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

  # Routes to Account Recovery View
  get  "/recovery", to: "recovery#new",    as: :'recovery'
  post "/recovery", to: "recovery#create"     # Handles Form Submission

  # Account Recovery Pass reset page
  get "/recovery/reset", to: "recovery#edit", as: :'recovery_reset'
  patch "/recovery/reset", to: "recovery#update"

  get "/gifts", to: "gifts#index", as: "gifts"
  get "/gifts/new", to: "gifts#new",   as: "new_gift"
  post "/gifts",     to: "gifts#create", as: "create_gift"
  post "/gifts/:id/toggle_wishlisted", to: "user_gift_statuses#toggle_wishlisted", as: "toggle_wishlisted_gift"
  post "/gifts/:id/toggle_ignored", to: "user_gift_statuses#toggle_ignored", as: "toggle_ignored_gift"

  get 'events/:id', to: 'events#show', as: 'event'
  post 'events/:id/invite', to: 'events#invite', as: 'invite_event'
  get "/invites", to: "invites#index", as: 'invites'
  post "invites/:id/accept", to: "invites#accept", as: 'accept_invite'

  resources :user_preferences, only: [:create, :destroy]
  get "/preferences", to: "preferences#index", as: :preferences
  post "/preferences/bulk_save", to: "preferences#bulk_save", as: :bulk_save_preferences
end
