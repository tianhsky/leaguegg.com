class VersionsController < ApplicationController
  respond_to :json
  
  def show
    # @server_version is fetched from before_filter in application_controller
  end

end
