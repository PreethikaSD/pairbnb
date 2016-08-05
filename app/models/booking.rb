class Booking < ActiveRecord::Base
	belongs_to :user
	belongs_to :listing
    validate :check_overlapping_bookings

    def check_overlapping_bookings
        unavailable_dates = listing.available_dates.pluck(:booked_date)
        dates_to_book = (start_date .. end_date).to_a
        non_overlapping_dates = dates_to_book - unavailable_dates
        if dates_to_book == non_overlapping_dates
        	return
        else	
        	errors.add(:overlapping_dates, "dates are already taken")
        end
    end

end
