Rails.application.routes.draw do
  resources :cats
  resources :documents
  resources :users

  post "users/document_create", to: "users#document_create"

  root to: "users#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
