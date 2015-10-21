Rails.application.routes.draw do

  resource :version, only: [:show]

  namespace :api do
    resource :featured, only: [:show]
    resource :game, only: [:show]
    resource :summoner, only: [:show] do
      resource :stats, only: [:show], controller: 'summoners/stats'
    end
    resource :rotation, only: [:show]
  end

  get 'app' => 'apps#show', as: :mobile
  get 'rotation' => 'rotations#show', as: :rotation
  get 'game/*region/*summoner_name' => 'games#show', as: :game_search
  get 'summoner/*region/*summoner_name' => 'summoners#show', as: :summoner_search
  get 'summoner/*region/*summoner_name/champion/*champion_name' => 'summoners/champions#show', as: :summoner_champion_search

  root :to => 'home#show'

end
