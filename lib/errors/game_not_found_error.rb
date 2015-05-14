module Errors

  class GameNotFoundError < NotFoundError
    def message
      'Summoner is not currently in game'
    end
  end

end