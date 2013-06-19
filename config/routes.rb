Evescore::Application.routes.draw do
  get "kills/log"

  get "api/verify"

  get "key/add"
  match "key/save"
  root :to => "home#index"
end
