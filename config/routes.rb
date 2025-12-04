Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'home#index'

  resources :admins, only: %i[destroy] do
    member do
      get 'line_info', to: 'admin/line_infos#edit'
      patch 'line_info', to: 'admin/line_infos#update'
    end
  end

  resources :students, only: %i[index] do
    collection do
      patch :bulk_update
    end
    member do
      get :schedules, to: 'students/schedules#show'
    end
  end

  resources :schedules, only: %i[index edit update]

  resources :sessions, only: %i[create destroy]
  get 'log_out', to: 'sessions#destroy', as: 'log_out'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  post '/line_webhook/callback', to: 'line_webhook#callback'

  get 'privacy', to: 'home#privacy'
  get 'term', to: 'home#term'

  get 'mock_login', to: 'schedules#mock_login' if Rails.env.development?
end
