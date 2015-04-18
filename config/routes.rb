Rails.application.routes.draw do

  namespace :api do
    resource :game, only: [:show]
    resource :summoner, only: [:show]
    resource :version, only: [:show]
  end

end
