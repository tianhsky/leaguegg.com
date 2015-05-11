class VersionsController < ApplicationController
  respond_to :json
  skip_before_filter :set_nav
  
  def show
    @version = SemVer.find
  end

end
