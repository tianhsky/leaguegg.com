class SearchesController < ApplicationController

  skip_before_filter :set_nav

  def show
    if search_type == 'game'
      if search_region.blank? || search_summoner.blank?
        redirect_to :back and return
      end
      redirect_to game_path({
        'region' => search_region,
        'summoner_name' => search_summoner
      })
    end
  end

  protected

  def search_type
    params['type']
  end

  def search_region
    params['region']
  end

  def search_summoner
    params['summoner']
  end

end
