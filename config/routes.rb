Rails.application.routes.draw do
  resources :hitters
  root to: 'hitters#index'
end
