# frozen_string_literal: true

Rails.application.routes.draw do
  resources :hitters do
    get 'contract' => 'hitter_contracts#edit', as: :contract
    post 'contract' => 'hitter_contracts#update'
    patch 'contract' => 'hitter_contracts#update'
    delete 'contract' => 'hitter_contracts#destroy'
  end

  resources :leagues do
    resources :teams, except: :index

    member do
      patch 'sort' => 'sort_leagues#update', as: :sort
    end
  end

  resources :teams, only: nil do
    resources :lineups
  end

  resources :lineups, only: nil do
    resources :spots, except: %i[index show]
  end

  root to: 'leagues#index'
end
