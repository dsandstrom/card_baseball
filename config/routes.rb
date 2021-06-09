# frozen_string_literal: true

Rails.application.routes.draw do
  resources :hitters
  root to: 'hitters#index'
end
