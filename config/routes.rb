Rails.application.routes.draw do
  get "/users/filter", to: "users#filter"
  resources :users

  root to: proc { [200, {}, ['']] }
end
