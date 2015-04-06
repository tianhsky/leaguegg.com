module Seasonable
	extend ActiveSupport::Concern
	included do
		before_validation :store_season_in_upper
	end
	def store_season_in_upper
		self.season = self.season.try(:upcase)
	end
end