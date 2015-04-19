class VersionsController < ApplicationController
  respond_to :json
  
  def show
    @version = SemVer.find
  end

end
