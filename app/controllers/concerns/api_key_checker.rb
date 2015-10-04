module ApiKeyChecker
  extend ActiveSupport::Concern
  included do
    before_filter :check_api_key
  end

  def check_api_key
    return # todo remove
    is_valid = false
    valid_api_keys = ['lolcaf-mobile-apikey']
    api_key = request.headers['api-key']
    if valid_api_keys.include?(api_key)
      is_valid = true
    end
    #todo, if not valid, throw err
    # raise if !is_valid
  end
end