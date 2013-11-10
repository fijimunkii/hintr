Hintr::Application.routes.draw do

  root to: 'welcome#index'

  resources :users do
    resources :likes
    resources :hints do
      resources :likes
    end
  end

end
