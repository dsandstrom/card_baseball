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

  resources :teams, only: nil do
    resources :lineups
    resources :hitters, only: :index
  end

  resources :lineups, only: nil do
    resources :spots, except: %i[index show]
  end

  root to: 'leagues#index'
end
