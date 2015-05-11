class ApiController < ApplicationController
  include Errors::RescueRateLimitError
  include Errors::RescueNotFoundError
  respond_to :json
  skip_before_filter :set_nav

end
