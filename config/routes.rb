Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "sessions#new"

  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  get "register", to: "users#new", as: :register
  resources :users, only: [:create]

  resource :profile, only: [:show, :update]

  resources :wild_pokemons, only: [:index], path: "wild"
  get "team", to: "team#index", as: :team
  get "repo", to: "repo#index", as: :repo

  resources :species, only: [:index, :show]
  resources :instances, only: [:show] do
    member do
      post :catch
      post :move_to_repo
      post :move_to_team
      post :release
    end
  end
end
