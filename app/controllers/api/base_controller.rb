module Api
  class BaseController < ApplicationController
    include ApiKeyChecker

    respond_to :json

  end
end