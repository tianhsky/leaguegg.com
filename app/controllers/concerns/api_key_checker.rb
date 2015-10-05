module ApiKeyChecker
  extend ActiveSupport::Concern
  included do
    before_filter :check_api_key
  end

  def check_api_key
    return if check_mobile_api_key
    return if check_web_api_token
  end

  def check_mobile_api_key
    api_key = request.headers['api-key']
    return false if api_key.blank?
    if api_key == AppConsts::MOBILE_API_KEY
      # api key match
    else
      # api key not match
      raise Errors::UnauthorizedError.new
    end
    true
  end

  def check_web_api_token
    request_token = request.headers['at']
    raise Errors::UnauthorizedError.new if request_token.blank?
    valid_token_unencrypted = "#{AppConsts::WEB_API_SALT}:#{request.fullpath}"
    md5 = Digest::MD5.new
    md5.update(valid_token_unencrypted)
    valid_token = md5.hexdigest
    if valid_token == request_token
      # api key match
    else
      # api key not match
      raise Errors::UnauthorizedError.new
    end
    true
  end

end