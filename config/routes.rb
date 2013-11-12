Hintr::Application.routes.draw do

  root to: 'welcome#index'

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  resources :users do
    match '/load_hints', to: 'users#load_hints'
    resources :matches
  end

end
