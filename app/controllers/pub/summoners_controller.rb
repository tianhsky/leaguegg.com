module Pub
  class SummonersController < Pub::BaseController

    def index
      @summoners = Summoner.page(page||0).per(limit||100)
    end

  end
end