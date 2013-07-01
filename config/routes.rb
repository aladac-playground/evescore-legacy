Evescore::Application.routes.draw do
  get "character/profile"
  get "character/all"

  match "/donate", :controller => :donate, :action => :index

  get "kills/log"
  get "/ladder", :controller => :kills, :action => :ladder

  get "api/verify"
  get "api/import_all"
  match "api/import"

  get "key/add"
  match "key/save"
  root :to => "home#index"
end
