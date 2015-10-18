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

  get 'app' => 'home#show'
  get 'rotation' => 'home#show'
  get 'game/*region/*summoner_name' => 'home#show'
  get 'summoner/*region/*summoner_name' => 'home#show'
  get 'summoner/*region/*summoner_name/champion/*champion_name' => 'home#show'

  root :to => 'home#show'

end
