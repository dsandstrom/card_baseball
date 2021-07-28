# frozen_string_literal: true

Rails.application.routes.draw do
  resources :players do
    get 'contract' => 'contracts#edit', as: :contract
    post 'contract' => 'contracts#update'
    patch 'contract' => 'contracts#update'
    delete 'contract' => 'contracts#destroy'
  end

  resources :leagues do
    resources :teams, except: :index

    member do
      patch 'sort' => 'sort_leagues#update', as: :sort
    end
  end

  resources :hitters, only: :index
  resources :pitchers, only: :index

  resources :teams, only: nil do
    resources :lineups
    resources :hitters, only: :index
    resources :pitchers, only: :index
    resources :rosters, except: :show
  end

  resources :lineups, only: nil do
    resources :spots, except: %i[index show]
  end

  resources :users

  # https://github.com/heartcombo/devise/wiki/
  # How-To:-Allow-users-to-edit-their-password
  # devise_for :users, path: 'auth', skip: :registrations
  devise_for :users,
             path: 'auth', skip: :registrations,
             controllers: { confirmations: 'users/confirmations' }
  devise_scope :user do
    get 'auth/edit' => 'users/registrations#edit', as: :edit_user_registration
    put 'auth' => 'users/registrations#update', as: :user_registration
  end

  get '/unauthorized' => 'static#unauthorized', as: :unauthorized

  root to: 'leagues#index'
end
