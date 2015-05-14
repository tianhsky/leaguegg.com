module Errors

  class NotFoundError < StandardError
    def status
      404
    end
    def message
      'Not found'
    end
  end

end