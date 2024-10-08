# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  get 'dashboard', to: 'dashboard#index'

  namespace :api do
    namespace :v1 do
      resources :tables
      resources :reservations do
        member do
          post :confirm
          post :cancel
        end
      end
    end
  end
end
