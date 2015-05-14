module Errors

  class SummonerNotFoundError < NotFoundError
    def message
      'Summoner could not be found'
    end
  end

end