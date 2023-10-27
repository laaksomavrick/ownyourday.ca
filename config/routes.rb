# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                            registrations: 'users/registrations' }

  resources :tasks, only: %i[index update]
  resources :adhoc_tasks, only: %i[new create]
  resources :goals, only: %i[index edit new create update destroy] do
    resources :milestones, only: %i[index new edit create update destroy]
  end

  resources :task_position, only: [:update]
  resources :goal_position, only: [:update]

  get 'me', to: 'me#edit'
  patch 'me', to: 'me#update'

  scope 'api' do
    get 'health_check', to: 'health_check#index'
  end

  root to: redirect('/tasks')
end
