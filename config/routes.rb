Rails.application.routes.draw do

  get "set_language/update"
  post "/rate" => "rater#create", :as => "rate"
  devise_for :admins, path: "admin",
    controllers: {sessions: "admin/sessions"}
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

  get "index" => "static_pages#index"
  root "static_pages#home"
  mount ActionCable.server => "/cable"
  namespace :admin do
    root "home#index", path: "/"
    resources :users
    resources :mini_pitches, only: :index
    resources :set_user, only: :create
    resources :pitches, except: [:new, :create, :show]
  end

  namespace :dashboard do
    root "statistics#index", path: "/"
    resources :pitches do
      resources :mini_pitches
      resources :rents
      resources :rent_managers
      resources :promotions
    end
    resources :statistics

  end

  resources :pitches
  resources :mini_pitches, only: [:index, :show, :new] do
    resources :comments, only: :create
  end

  get "search(/:search)", to: "searches#index", as: :search
  resources :check_mini_pitches, only: :index
  resources :rents
  resources :matches
  resources :match_users
  resources :search_mini_pitches



  
  
  resources :user_domains
  resources :shop_domains

  resources :shops, only: [:index, :show, :update]
  resources :products, only: [:index, :show, :new] do
    resources :comments, only: :create
  end
  resources :comments, only: :destroy
  resources :carts
  resources :orders
  resource :orders
  resources :users
  resources :events, only: [:index, :update] do
    post :read_all, on: :collection
  end
  resources :categories do
    resources :products
  end
  resources :tags, only: :show
  

  resources :request_shop_domains
  resources :set_carts
  resources :pdf_readers, only: :index
  resources :user_searchs

  api_version(module: "V1", path: {value: "v1"}, default: true) do
    namespace :dashboard do
      resources :shops, only: :index, defaults: {format: :json}
      resources :order_managers, only: :index, defaults: {format: :json}
    end
    resources :shop_domains, defaults: {format: :json}
    resources :orders_product_all, defaults: {format: :json}
    resources :domains, only: :index, defaults: {format: :json}
    resources :authen_user_tokens, only: :index, defaults: {format: :json}
    resources :products, only: :index, defaults: {format: :json}
    get "/logout", to: "users_logout#logout", defaults: {format: :json}
    resources :categories, only: :index, defaults: {format: :json}
    resources :orders, defaults: {format: :json}
  end
end
