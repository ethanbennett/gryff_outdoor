Rails.application.routes.draw do

  root 'landing#index'
  delete '/carts', to: "carts#destroy", as: "carts"
  get '/cart', to: "carts#show", as: "cart"
  patch '/cart' => 'carts#update'
  resources :items, only: [:index, :show, :update]
  resources :carts, only: [:create]
  resources :users, only: [:new, :create, :show, :edit, :update] do
    resources :addresses, only: [:new, :create, :edit, :destroy]
  end
  namespace :admin do
    get '/dashboard', to: "orders#dashboard"
    resources :orders, only: [:edit, :update]
    resources :items, only: [:index, :update, :edit]
    resources :users, only: [:show]
  end
  resources :orders, only: [:index, :show, :create]
  resources :charges, only: [:new, :create]
  get '/dashboard', to: "users#show"
  post '/login', to: "sessions#create"
  get '/login', to: "sessions#new"
  get '/logout', to: "sessions#destroy"
  get '/:category' => 'categories#index'
  patch '/carts/:id' => 'carts#update'
end
