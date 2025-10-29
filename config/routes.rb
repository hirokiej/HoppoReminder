Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root 'home#index'
  resources :admins do
    member do
      get 'line_info', to: 'admin/line_infos#edit'
      patch 'line_info', to: 'admin/line_infos#update'
    end
  end
  resources :students do
    collection do
      patch :bulk_update
    end
  end
  namespace :students do
    get 'schedules/show'
  end
  resources :schedules, only: %i[index edit update]

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'log_out', to: 'sessions#destroy', as: 'log_out'
  post '/line_webhook/callback', to: 'line_webhook#callback'

  resources :sessions, only: %i[create destroy]
  resources :students, only: :index

  get 'privacy', to: 'home#privacy'
  get 'term', to: 'home#term'
end
