Evescore::Application.routes.draw do
  get "api/verify"

  get "key/add"
  match "key/save"
  root :to => "home#index"
end
