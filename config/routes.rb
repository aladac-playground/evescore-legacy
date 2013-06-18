Evescore::Application.routes.draw do
  get "api/verify"

  get "key/add"
  get "key/save"

  root :to => "home#index"
end
