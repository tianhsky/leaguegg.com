Rails.application.routes.draw do

  resource :version, only: [:show]

  namespace :pub do
    resource :home, only: [:show]
    resources :summoners, only: [:index]
  end

  namespace :api do
    resource :featured, only: [:show]
    resource :game, only: [:show]
    resource :summoner, only: [:show] do
      resource :stats, only: [:show], controller: 'summoners/stats'
    end
    resource :rotation, only: [:show]
  end

  get 'app' => 'home#show', as: :mobile
  get 'rotation' => 'home#show', as: :rotation
  get 'game/*region/*summoner_name' => 'home#show', as: :game_search
  get 'summoner/*region/*summoner_name' => 'home#show', as: :summoner_search
  get 'summoner/*region/*summoner_name/champion/*champion_name' => 'home#show', as: :summoner_champion_search

  root :to => 'home#show'

end
