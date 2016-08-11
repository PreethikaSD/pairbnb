class Listing < ActiveRecord::Base
  mount_uploaders  :avatars, AvatarUploader
	belongs_to :user
	has_many :listing_tags
	has_many :tags, :through => :listing_tags
	has_many :bookings
	has_many :available_dates
  searchkick
  
  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: [
      :search_query,
      :sorted_by,
      :with_country_id,
      :with_tag_ids
    ]
  )

scope :search_query, lambda { |query|
  return nil  if query.blank?

  terms = query.downcase.split(/\s+/)

  terms = terms.map { |e|
    (e.gsub('*', '%') + '%').gsub(/%+/, '%')
  }

  num_or_conds = 2
  where(
    terms.map { |term|
      "(LOWER(listings.title) LIKE ? OR LOWER(listings.address) LIKE ?)"
    }.join(' AND '),
    *terms.map { |e| [e] * num_or_conds }.flatten
  )
}

scope :sorted_by, lambda { |sort_option|
  direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
  case sort_option.to_s
  when /^price/
    order("(listings.price) #{ direction }")
  when /^created_at_/
    order("listings.created_at #{ direction }")
  when /^title_/
         # Simple sort on the name colums
    order("LOWER(listings.title) #{ direction }")
  when /^country_code_/
        # This sorts by a student's country name, so we need to include
        # the country. We can't use JOIN since not all students might have
         # a country.
    order("LOWER(listings.country_code) #{ direction }")

  else
    raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
  end
}

scope :with_country_id, lambda { |country_ids|
  where(country_code: country_ids)
}
 
scope :with_tag_ids, lambda { |tag_ids|
  joins(:tags).where(tags: {id: tag_ids})
}


def self.options_for_sorted_by
  [
    ['Title (a-z)', 'title_asc'],
    ['Creation Date (newest first)', 'created_at_desc'],
    ['Creation Date (oldest first)', 'created_at_asc'],
    ['Country (a-z)', 'country_code_asc'],
    ['Price (high-low)', 'price_desc'],
    ['Price (low-high)', 'price_asc']

    ]
end

def self.countries_with_listings
  arr = ISO3166::Country.all.map {|c| [c.name, c.alpha2]}
  arr = arr.delete_if{|c| Listing.find_by(country_code: c[1]).nil? }
  return arr
end

end
