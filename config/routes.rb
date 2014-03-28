Evescore::Application.routes.draw do
  get "tools/dps"
  get "stats/factions"
  get "stats/progress"
  resources :corps

  get "top/rats"
  get "top/ticks"
  get "top/kills"
  get "top/income"
  get "top/bounty"
  get "top/incursion"
  get "top/corp"
  get "top/alliance"
  get "top/mission"
  get "top/mission_time"
  get "top/mission_all"  
  get "ratopedia/factions"
  get "ratopedia/groups"
  get "search/ajax"
  get "search/ajax_rats"
  get "search/result"
  get "rats/faction/:faction", to: "rats#groups"
  get "rats/factions", to: "rats#factions"
  get "rats/type/:rat_type", to: "rats#rat_type"
  resources :rats
  get "wallet/index"
  get "home/test"
  get "home/legal"
  resources :chars

  resources :examples

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :keys
  resources :users
end