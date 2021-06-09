# frozen_string_literal: true

Rails.application.routes.draw do
  resources :leagues
  resources :hitters
  root to: 'hitters#index'
end
