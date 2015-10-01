module Errors

  class LeagueNotFoundError < NotFoundError
    def message
      'League could not be found'
    end
  end

end