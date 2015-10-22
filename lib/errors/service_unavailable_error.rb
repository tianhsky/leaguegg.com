module Errors

  class ServiceUnavailableError < StandardError
    def status
      503
    end
    def message
      'Service Unavailable'
    end
  end

end