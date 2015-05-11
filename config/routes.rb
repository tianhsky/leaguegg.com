Rails.application.routes.draw do

  resource :version, only: [:show]
  resource :rotation, only: [:show]
  resource :app, only: [:show]
  resource :search, only: [:show]

  namespace :api do
    resource :game, only: [:show]
    resource :summoner, only: [:show]
  end

  get 'game/*region/*summoner_name' => 'games#show', as: 'game'
  get 'summoner/*region/*summoner_name' => 'summoners#show', as: 'summoner'

  root :to => 'home#index'

end
