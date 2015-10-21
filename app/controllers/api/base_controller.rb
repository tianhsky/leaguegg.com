module Api
  class BaseController < ApplicationController
    include ApiErrorRescuers
    include ApiKeyChecker

    respond_to :json

  end
end