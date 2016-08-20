require 'rails_helper'

RSpec.describe Listing, type: :model do
	it { is_expected.to belong_to(:user) }
	it {is_expected.to have_many(:bookings)}
	it {is_expected.to have_many(:listing_tags)}
	it {is_expected.to have_many(:available_dates)}
	it {is_expected.to have_many(:tags).through(:listing_tags)}
end

