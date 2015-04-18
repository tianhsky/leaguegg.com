module Api
  class VersionsController < ApiController

    def show
      @version = SemVer.find
    end

  end
end