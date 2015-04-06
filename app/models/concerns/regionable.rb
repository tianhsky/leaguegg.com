module Regionable
	extend ActiveSupport::Concern
	included do
		before_validation :store_region_in_upper
	end
	def store_region_in_upper
		self.region = self.region.try(:upcase)
	end
end