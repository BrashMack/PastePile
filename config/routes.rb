# frozen_string_literal: true

Rails.application.routes.draw do
  resources :pastes
  resources :users
  resources :sessions, only: %i[new create destroy]
  get '/signin', to: 'sessions#new'
  get '/signup', to: 'users#new'
  root 'pastes#new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
