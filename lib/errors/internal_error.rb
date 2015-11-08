module Errors

  class InternalError < StandardError
    def status
      500
    end
    def message
      'Internal Error'
    end
  end

end