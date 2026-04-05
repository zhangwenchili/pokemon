Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      post   "auth/register", to: "auth#register"
      post   "auth/login", to: "auth#login"
      delete "auth/logout", to: "auth#logout"
      get    "profile", to: "profiles#show"
      patch  "profile", to: "profiles#update"
      resources :wild_pokemons, only: [:index]
      get "team", to: "team#index"
      get "repo", to: "repo#index"
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
  end

  devise_for :users,
             path: "",
             path_names: { sign_in: "login", sign_out: "logout", sign_up: "register" },
             controllers: {
               sessions: "users/sessions",
               registrations: "users/registrations"
             }

  devise_scope :user do
    root to: "users/sessions#new"
  end

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
