Rails.application.routes.draw do
  post "sign_in", to: "sessions#create"
  post "sign_up", to: "registrations#create"
  get  "sign_out", to: "sessions#destroy"
  resources :sessions, only: [:show, :destroy]
  resource  :password, only: [:edit, :update]
  namespace :identity do
    resource :password_reset,     only: [:new, :edit, :create, :update]
  end

  namespace :api do
    namespace :v1 do
      resource :current_user, only: [:show], controller: :current_user

      resources :posts, only: [:index, :show] do 
        resources :ratings, controller: 'posts/ratings', only: [:index]
        resources :views, controller: 'posts/views', only: [:create, :index]
      end

      resources :users do 
        resources :posts, controller: 'users/posts' do 
          # Rating is a singular resource for a post from a users perspective.
          resource :rating, controller: 'users/ratings'
        end
      end
    end
  end

  namespace :admin_api do
    namespace :v1 do
      resources :users, only: [:index]
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # Health check
  get "health" => "health#show", as: :health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Admin routes - any path starting with /admin goes to admin
  get "admin/*path" => "home#admin", as: :admin
  get "admin" => "home#admin", as: :admin_root

  # Defines the root path route ("/")
  root "home#index"
  get "/*path" => "home#index", as: :app
end
