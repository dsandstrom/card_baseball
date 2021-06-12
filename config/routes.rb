# frozen_string_literal: true

Rails.application.routes.draw do
  resources :hitters
  resources :leagues do
    resources :teams, except: :index
  end

  root to: 'leagues#index'
end
