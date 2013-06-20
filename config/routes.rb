Evescore::Application.routes.draw do
  match "/donate", :controller => :donate, :action => :index

  get "kills/log"

  get "api/verify"

  get "key/add"
  match "key/save"
  root :to => "home#index"
end
