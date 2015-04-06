class ApiController < ApplicationController
  include Errors::RescueRateLimitError
  include Errors::RescueNotFoundError
  respond_to :json

end
