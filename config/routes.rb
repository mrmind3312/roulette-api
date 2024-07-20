Rails.application.routes.draw do
  devise_for :users,
             controllers: { sessions: 'users/sessions' },
             defaults: { format: :json },
             path: 'api/auth',
             path_names: { sign_in: 'login', sign_out: 'logout' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  scope :api do
    scope :v1 do
      namespace :catalog do
        resources :hours
      end

      resources :services do
        resources :hours, controller: 'services/hours'
      end

      resources :users do
        resources :availabilities, controller: 'users/availabilities'
      end
    end
  end
end
