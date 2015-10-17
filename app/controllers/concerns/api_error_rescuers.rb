module ApiErrorRescuers
  extend ActiveSupport::Concern
  included do
    rescue_from Errors::GameNotFoundError do |e|
      render json: {error: e.message, status: e.status}, status: e.status
    end
    rescue_from Errors::SummonerNotFoundError do |e|
      render json: {error: e.message, status: e.status}, status: e.status
    end
    rescue_from Errors::RateLimitError do |e|
      render json: {error: e.message, status: e.status}, status: e.status
    end
    rescue_from Errors::UnauthorizedError do |e|
      render json: {error: e.message, status: e.status}, status: e.status
    end
    rescue_from Errors::StatsNotFoundError do |e|
      render json: {error: e.message, status: e.status}, status: e.status
    end
  end
end