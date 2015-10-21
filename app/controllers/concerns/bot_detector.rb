module BotDetector
  extend ActiveSupport::Concern

  def is_crawler?
    params.has_key?('_escaped_fragment_')
  end

end