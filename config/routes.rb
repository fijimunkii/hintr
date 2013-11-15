Hintr::Application.routes.draw do

  root to: 'welcome#index'

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  post 'remove_match/:id', to: 'matches#remove_match'

  post 'users/set_interest', to: 'users#set_interest'
  get 'users/latest_match', to: 'users#latest_match'

  resources :users do
    match '/load_intro', to: 'users#load_intro'
    match '/load_hints', to: 'users#load_hints'
    resources :matches
  end

  mount Resque::Server, :at => "/resque"

end
