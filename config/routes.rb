Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get "/api/v1/merchants/find", to: "api/v1/merchants#find"
  get "/api/v1/items/find_all", to: "api/v1/items#find_all"

  # get "/api/v1/items/id/merchant", to:
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: :index
      end
      resources :items do
        resources :merchant, only: :index, action: :index, controller: '/api/v1/item_merchants'
      end
    end
  end
end
