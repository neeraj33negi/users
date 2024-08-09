Rails.application.routes.draw do
  devise_for :users
  get "/users/filter", to: "users#filter"
  resources :users
  resources :all_users, to: "users#all"

  root to: proc { [200, {}, ['']] }
end
