Rails.application.routes.draw do

  namespace :api do
    resource :featured, only: [:show]
    resource :game, only: [:show]
    resource :summoner, only: [:show]
    resource :rotation, only: [:show]
    resources :matches, only: [:index]
  end
  resource :version, only: [:show]


  resource :app, only: [:show]
  resource :rotation, only: [:show]
  resource :search, only: [:show]

  # get 'app' => 'home#show'
  # get 'rotation' => 'home#show'
  # get 'game/*region/*summoner_name' => 'home#show'
  # get 'summoner/*region/*summoner_name' => 'home#show'

  get 'game/*region/*summoner_name' => 'games#show', as: 'game'
  get 'summoner/*region/*summoner_name' => 'summoners#show', as: 'summoner'

  root :to => 'home#show'

end
