class SummonersController < BaseController

  def show
    if is_crawler?
      find_summoner
    else
      render 'angular/wrapper'
    end
  end

  protected

  def find_summoner
    if summoner_id.present?
      @summoner = SummonerService::Service.find_summoner_by_summoner_id(summoner_id, region)
    elsif summoner_name.present?
      @summoner = SummonerService::Service.find_summoner_by_summoner_name(summoner_name, region)
    end

    if @summoner && reload?
      if @summoner.outdated?
        @summoner.sync_from_riot!
      end
    end
  end

  def summoner_id
    tokens = summoner_id_or_name.split('-')
    if tokens.length == 2
      return tokens[0]
    end
    nil
  end

  def summoner_name
    tokens = summoner_id_or_name.split('-')
    if tokens.length == 1
      return tokens[0]
    else
      if tokens.length == 2
        return tokens[1]
      end
    end
    nil
  end

  def summoner_id_or_name
    params['summoner_id_or_name']
  end

  def region
    params['region']
  end

  def reload?
    params[:reload].blank? ? false : true
  end

end
