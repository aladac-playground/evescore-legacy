Evescore::Application.routes.draw do
  get "info/badges"
  get "ladder/bounty"

  get "ladder/incursion"

  get "home/corps"
  
  get "blitz/test"
  
  get "rats/show"

  get '/mu-70933399-cf59f263-41132851-471e4059', :controller => :blitz, :action => :test do
    '42'
  end
  get "corp/profile"

  get "info/about"

  get "info/faq"

  get "info/changelog"
  
  get "info/contact"

  get "character/profile"
  get "character/all"

  match "/donate", :controller => :donate, :action => :index

  get "kills/log"
  get "kills/ratlog"
  get "/ladder", :controller => :kills, :action => :ladder

  match "api/search"
  get "api/verify"
  get "api/import_all"
  match "api/import"

  get "key/add"
  get "key/delete"
  match "key/save"
  match "key/delete"
  
  match "/irs", :controller => :home, :action => :taxes
  
  root :to => "home#index"
end
