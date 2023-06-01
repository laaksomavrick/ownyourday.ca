# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                            registrations: 'users/registrations' }

  resources :tasks, only: [:index, :update]
  resources :adhoc_tasks, only: %i[new create]
  resources :goals, only: %i[index edit new create update destroy]

  root to: redirect('/tasks')
end
