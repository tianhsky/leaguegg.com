module Platformable
  extend ActiveSupport::Concern
  included do
    before_validation :store_platform_id_in_upper
  end
  def store_platform_id_in_upper
    self.platform_id = self.platform_id.try(:upcase)
  end
end