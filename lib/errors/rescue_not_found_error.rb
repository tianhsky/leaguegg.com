module Errors

  module RescueNotFoundError

    def self.included(base)
      base.rescue_from Errors::NotFoundError do |e|
        render json: {error: 'Not found'}, status: 404
      end
    end

  end

end