Rails.application.routes.draw do
  #  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  #  resources :users, controller: "clearance/users", only: [:create] do
  #    resource :password,
  #      controller: "clearance/passwords",
  #      only: [:edit, :update]
  #  end

  get "/sign_in" => "clearance/sessions#new", :as => "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", :as => "sign_out"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # resources are protected
  constraints Clearance::Constraints::SignedIn.new do
    resources :menus
    resources :events, except: [:show, :index] do
      resources :pages
      resources :activities, except: [:show, :index]
    end

    resources :people, except: [:show]
  end

  # these are public

  resources :events, only: [:show, :index] do
    resources :activities, only: [:show, :index]
    resource :schedule, only: [:show]
  end

  get "/events/:event_id/teachers" => "people#facilitators"
  get "/teachers" => "people#facilitators"
  get "/events/:event_id/*slug" => "pages#show"
  resources :people, only: [:show]

  # uses "current" event
  get "/activities" => "activities#index"
  get "/classes" => "activities#index"
  get "/schedule" => "schedules#show"
  get "/*slug" => "pages#show"
  root "pages#show", defaults: {slug: "home"}

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
