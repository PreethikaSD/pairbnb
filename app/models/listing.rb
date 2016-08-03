class Listing < ActiveRecord::Base
	belongs_to :user
	has_many :listing_tags
	has_many :tags, :through => :listing_tags

  filterrific(
    default_filter_params: { search_query: '' },
    available_filters: [
      :search_query
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
end
