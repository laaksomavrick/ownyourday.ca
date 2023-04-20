# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :today, only: [:index]
  resources :goals, only: %i[index show]

  root to: redirect('/today')
end
