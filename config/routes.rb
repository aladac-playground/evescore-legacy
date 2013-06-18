Evescore::Application.routes.draw do
  get "api/verify"

  get "key/add"

  root :to => "home#index"
end
