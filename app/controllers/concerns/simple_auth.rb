module SimpleAuth
  extend ActiveSupport::Concern

  def simple_authenticate
    user = AppConsts::ADMIN_USER
    pass = AppConsts::ADMIN_PASS
    if authenticate_with_http_basic { |u, p| user==u && pass==p }
      # auth success
    else
      request_http_basic_authentication
    end

  end

end