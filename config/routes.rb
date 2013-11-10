Hintr::Application.routes.draw do

  root to: 'welcome#index'

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  resources :users do
    resources :likes
    resources :hints do
      resources :likes
    end
  end

end
