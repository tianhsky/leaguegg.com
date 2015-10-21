class BaseController < ApplicationController
  respond_to :html

  layout :select_layout

  def select_layout
    if is_crawler?
      return 'application_crawler'
    end
    'application'
  end

end