class SummonersController < BaseController

  def show
    if is_crawler?
      find_summoner
      generate_description
    else
      render 'angular/wrapper'
    end
  end

  protected

  def find_summoner
    if summoner_name.present?
      @summoner = Summoner::Service.find_summoner_by_summoner_name(summoner_name, region)
    elsif summoner_id.present?
      @summoner = Summoner::Service.find_summoner_by_summoner_id(summoner_id, region)
    end

    if @summoner && reload?
      if @summoner.outdated?
        @summoner.sync_from_riot!
      end
    end
  end

  def generate_description
    league = @summoner.primary_league
    @summoner_description = "#{@summoner.name}'s League of Legends Stats, Level #{@summoner.summoner_level}, #{@summoner.region_name}"
    @summoner_description += ", #{league['tier']} #{league['division']} in #{league['name']}" if league
  end

  def summoner_id
    params['summoner_id']
  end

  def summoner_name
    params['summoner_name']
  end

  def region
    params['region']
  end

  def reload?
    params[:reload].blank? ? false : true
  end

end
