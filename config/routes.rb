# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                            registrations: 'users/registrations' }

  resources :today, only: [:index]
  resources :goals, only: %i[index edit new create update destroy]

  root to: redirect('/today')
end
