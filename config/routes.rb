Rails.application.routes.draw do
  # Authentication
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  # Public pages
  root "home#index"
  get "about", to: "pages#about"
  get "pricing", to: "pages#pricing"

  # Public marketplace
  resources :components, only: [:index, :show], param: :slug
  resources :categories, only: [:index, :show], param: :slug
  resources :developers, only: [:show], param: :username

  # Developer area
  namespace :developers do
    resource :dashboard, only: [:show]
    resources :components do
      resources :versions, controller: "component_versions"
    end
    resource :earnings, only: [:show]
    resources :payouts, only: [:index, :show]
    resource :profile, only: [:show, :edit, :update]
    resource :stripe_account, only: [:new, :create, :show]
  end

  # Enterprise area
  namespace :enterprises do
    resource :dashboard, only: [:show]
    resource :organization, only: [:show, :edit, :update, :new, :create]
    resources :members, only: [:index, :create, :destroy]
    resources :invitations, only: [:create, :destroy]
    resource :subscription, only: [:show, :new, :create, :edit, :update, :destroy]
    resources :licenses, only: [:index, :show, :new, :create]
    resources :downloads, only: [:index]
  end

  # Admin area
  namespace :admin do
    root "dashboard#index"
    resources :users
    resources :organizations
    resources :components do
      member do
        post :approve
        post :reject
        post :feature
      end
    end
    resources :categories
    resources :subscriptions
    resources :transactions, only: [:index, :show]
    resources :payouts, only: [:index, :show, :update]
    resources :reviews, only: [:index, :show, :destroy]
    resource :settings, only: [:show, :update]
  end

  # API
  namespace :api do
    namespace :v1 do
      resources :components, only: [:index, :show], param: :slug do
        resources :versions, only: [:index, :show]
      end
      resources :categories, only: [:index]
      resource :me, only: [:show, :update]
    end
  end

  # Webhooks
  post "webhooks/stripe", to: "webhooks#stripe"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
