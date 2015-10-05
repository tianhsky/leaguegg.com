module Errors

  class UnauthorizedError < StandardError
    def status
      401
    end
    def message
      'Not authorized'
    end
  end

end