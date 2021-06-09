# frozen_string_literal: true

Rails.application.routes.draw do
  resources :hitters
  resources :leagues do
    resources :teams
  end

  root to: 'leagues#index'
end
