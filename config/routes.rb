Rails.application.routes.draw do
  resources :cats
  root to: "cats#index"
end
