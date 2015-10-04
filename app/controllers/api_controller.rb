class ApiController < ApplicationController
  include ApiErrorRescuers
  include ApiKeyChecker
  
  respond_to :json
  skip_before_filter :set_nav

end
