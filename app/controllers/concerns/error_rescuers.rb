module ErrorRescuers
  extend ActiveSupport::Concern
  included do
    rescue_from Errors::GameNotFoundError do |e|
      respond_to do |format|
        format.html { render text: e.message, status: e.status }
        format.json { render json: {error: e.message, status: e.status}, status: e.status }
      end
    end
    rescue_from Errors::SummonerNotFoundError do |e|
      respond_to do |format|
        format.html { render text: e.message, status: e.status }
        format.json { render json: {error: e.message, status: e.status}, status: e.status }
      end
    end
    rescue_from Errors::RateLimitError do |e|
      respond_to do |format|
        format.html { render text: e.message, status: e.status }
        format.json { render json: {error: e.message, status: e.status}, status: e.status }
      end
    end
    rescue_from Errors::ServiceUnavailableError do |e|
      respond_to do |format|
        format.html { render text: e.message, status: e.status }
        format.json { render json: {error: e.message, status: e.status}, status: e.status }
      end
    end
    rescue_from Errors::UnauthorizedError do |e|
      respond_to do |format|
        format.html { render text: e.message, status: e.status }
        format.json { render json: {error: e.message, status: e.status}, status: e.status }
      end
    end
    rescue_from Errors::StatsNotFoundError do |e|
      respond_to do |format|
        format.html { render text: e.message, status: e.status }
        format.json { render json: {error: e.message, status: e.status}, status: e.status }
      end
    end
  end
end