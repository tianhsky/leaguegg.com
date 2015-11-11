module Api
  class FeedbacksController < Api::BaseController

    protect_from_forgery with: :null_session
    skip_before_filter :check_api_key
    include SimpleAuth

    def index
      simple_authenticate
      @feedbacks = Feedback.order_by(['created_at', -1])
    end

    def create
      @feedback = Feedback.create(feedback_params)
      render json: {}
    end

    protected

    def feedback_params
      fb = JSON.parse(params['feedback'])
    end

  end
end