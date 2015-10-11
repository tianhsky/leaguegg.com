module ServerVersionChecker
  extend ActiveSupport::Concern
  included do
    before_filter :check_server_version
  end

  def check_server_version
    response.headers['server-version'] = AppConsts::SERVER_VERSION
  end

end