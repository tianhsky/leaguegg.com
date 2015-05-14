class ApiController < ApplicationController
  include ApiErrorRescuers
  
  respond_to :json
  skip_before_filter :set_nav

end
