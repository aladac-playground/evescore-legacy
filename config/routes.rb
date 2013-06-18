Evescore::Application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  get "api/verify"

  get "key/add"
  match "key/save"
  root :to => "home#index"
end
