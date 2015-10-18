module Pub
  class BaseController < ApplicationController

    skip_before_filter :check_server_version
    layout 'empty'

    protected

    def page
      params['page']
    end

    def limit
      params['limit']
    end

  end
end