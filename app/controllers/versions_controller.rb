class VersionsController < ApplicationController
  respond_to :json
  skip_before_filter :set_nav
  
  def show
    # @server_version is fetched from before_filter in application_controller
  end

end
