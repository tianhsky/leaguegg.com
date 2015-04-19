Rails.application.routes.draw do

  namespace :api do
    resource :game, only: [:show]
    resource :summoner, only: [:show]
  end
  resource :version, only: [:show]

  root :to => 'home#index'

end
