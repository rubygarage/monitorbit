Rails.application.routes.draw do
  resources :client_errors, only: %i[index]
  resources :server_errors, only: %i[index]
  resources :jobs, only: %i[index]
  resources :things, only: %i[index show]
end
