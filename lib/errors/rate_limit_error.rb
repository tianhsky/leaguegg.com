module Errors

  class RateLimitError < StandardError
    def status
      429
    end
    def message
      'Exceed rate limit'
    end
  end

end