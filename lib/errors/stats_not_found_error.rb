module Errors

  class StatsNotFoundError < NotFoundError
    def message
      'Stats could not be found'
    end
  end

end