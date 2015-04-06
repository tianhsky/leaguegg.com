module Errors

  module RescueRateLimitError

    def self.included(base)
      base.rescue_from Errors::RateLimitError do |e|
        render json: {error: 'Exceed rate limit'}, status: 429
      end
    end

  end

end