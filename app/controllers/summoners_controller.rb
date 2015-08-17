class SummonersController < ApplicationController

  def show
    begin
      @summoner = Summoner::Service.find_summoner_by_summoner_name(summoner_name, region)
      if reload?
        should_reload = reload?
      else
        should_reload = true if @summoner.recent_matches_update_expired?
      end
      @recent_matches = @summoner.recent_matches(should_reload)
      @recent_stats = SummonerMatch.aggretate_stats(@recent_matches)
      if last_game = @recent_matches.first
        @last_champion_played = Consts::Champion.find_by_id(last_game.champion_id)
      end
    rescue Exception => ex
      @error = ex
    end
  end

  protected

  def region
    params['region'].try(:downcase)
  end

  def summoner_name
    params['summoner_name']
  end

  def set_nav
    @nav = 'summoner'
  end

  def reload?
    params[:reload].blank? ? false : true
  end

end
