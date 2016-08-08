class Tag < ActiveRecord::Base
	has_many :listing_tags
	has_many :listings, :through => :listing_tags

	def self.options_for_select
	   order('LOWER(name)').map { |e| [e.name, e.id] }
	end
end
