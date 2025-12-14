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

  #Change Password
  patch '/change_password', to: 'users#update_password', as: :change_password
  get '/change_password', to: 'users#change_password'  # page itself

  get "/gifts", to: "gifts#index", as: "gifts"
  get "/gifts/new", to: "gifts#new",   as: "new_gift"
  post "/gifts",     to: "gifts#create", as: "create_gift"

  get "/gifts/:id", to: "gifts#show", as: "gift"
  get "/gifts/:id/edit", to: "gifts#edit",   as: "edit_gift"
  patch "/gifts/:id",      to: "gifts#update"
  delete "/gifts/:id",      to: "gifts#destroy"

  post "/gifts/:id/toggle_wishlisted", to: "user_gift_statuses#toggle_wishlisted", as: "toggle_wishlisted_gift"
  post "/gifts/:id/toggle_ignored", to: "user_gift_statuses#toggle_ignored", as: "toggle_ignored_gift"

  post "/gifts/:id/upvote",   to: "gifts#upvote",   as: "upvote_gift"
  post "/gifts/:id/downvote", to: "gifts#downvote", as: "downvote_gift"

  get "events/:id/add", to: "events#add", as: "add_event_gift"
  get "events/:id/select_gift/:recipient_id", to: "events#show", as: "select_gift_event"
  post "events/:id/assign_gift/:recipient_id/:gift_id", to: "events#assign_gift", as: "assign_gift_event"
  post "events/:id/remove_gift/:recipient_id", to: "events#remove_gift", as: "remove_gift_event"
  post "events/:id/assign_roles", to: "events#assign_roles", as: :assign_roles_event
  post "/events/:id/remove_assignment", to: "events#remove_assignment", as: :remove_assignment_event

  get 'events/:id', to: 'events#show', as: 'event'
  post 'events/:id/invite', to: 'events#invite', as: 'invite_event'
  post 'events/:id/invite_friends', to: 'events#invite_friends', as: 'invite_friends_event' # Multiple Friends Invite

  delete "events/:id/remove_attendee", to: "events#remove_attendee", as: "remove_attendee_event"
  get 'events/:event_id/gift_ideas/recipients', to: 'events/gift_ideas#recipients', defaults: { format: :json }
  post 'events/:event_id/gift_ideas/generate', to: 'events/gift_ideas#generate', defaults: { format: :json }
  post 'events/:event_id/gift_ideas/chat', to: 'events/gift_ideas#chat', defaults: { format: :json }
  get "/invites", to: "invites#index", as: 'invites'
  post "invites/:id/accept", to: "invites#accept", as: 'accept_invite'
  post "events/:id/add_recipient", to: "events#add_recipient", as: 'add_recipient_event'

  resources :user_preferences, only: [:create, :destroy]
  get "/preferences", to: "preferences#index", as: :preferences
  post "/preferences/bulk_save", to: "preferences#bulk_save", as: :bulk_save_preferences

  resources :friendships, only: %i[index create update destroy]
  match "*path", to: redirect("/events"), via: :all

end
