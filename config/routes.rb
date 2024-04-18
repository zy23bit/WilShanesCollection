Rails.application.routes.draw do
  root 'home#index'
  get 'about', to: 'static_pages#show', defaults: { identifier: 'about' }, as: :about
  get 'contact', to: 'static_pages#show', defaults: { identifier: 'contact' }, as: :contact
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  resources :users do
    resources :addresses
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :static_pages, only: [:show, :edit, :update]


  resources :products

  resources :cart_items, only: [:create, :update, :destroy]
  resource :cart, only: [:show]
  post 'add_to_cart/:product_id', to: 'cart_items#create', as: 'add_to_cart'
  resources :payments, only: [:new, :create] do
    collection do
      get 'calculate_tax', to: 'payments#calculate_tax_endpoint',as: :calculate_tax
    end
  end
  resources :orders, only: [:index, :show]

end
