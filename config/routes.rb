Rails.application.routes.draw do

  resource :version, only: [:show]

  namespace :api do
    resource :featured, only: [:show]
    resource :game, only: [:show]
    resource :summoner, only: [:show] do
      resource :stats, only: [:show], controller: 'summoners/stats'
      resources :matches, only: [:index], controller: 'summoners/matches'
    end
    resource :rotation, only: [:show]
    resources :matches, only: [:index, :show]
    resources :cbuilds, only: [:index]
    resources :feedbacks, only: [:index, :create]
  end

  get 'app' => 'apps#show', as: :mobile
  get 'rotation' => 'rotations#show', as: :rotation
  get 'feedbacks' => 'feedbacks#index', as: :feedbacks
  get 'game/*region/*summoner_name' => 'games#show', as: :game_search
  # get 'match/*region/*match_id' => 'matches#show', as: :match_search
  get 'summoner/*region/*summoner_id_or_name' => 'summoners#show', as: :summoner_search
  get 'summoner/*region/*summoner_id_or_name/champion/*champion_id' => 'summoners/champions#show', as: :summoner_champion_search
  get 'summoner/*region/*summoner_id_or_name/matches' => 'summoners/matches#index', as: :summoner_matches_search
  get 'summoner/*region/*summoner_id_or_name/matches/*match_id' => 'summoners/matches#show', as: :summoner_match_search

  root :to => 'home#show'

end
