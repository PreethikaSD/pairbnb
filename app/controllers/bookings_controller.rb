class BookingsController < ApplicationController

	def index
		@bookings = current_user.bookings.all
	end	

	def new
		@booking = Booking.new
		set_listing
	end

	def create
		if signed_in? and current_user
        	set_listing
        	@booking = current_user.bookings.new(booking_params)
        	@booking.listing = @listing
			if @booking.save
				reserve_dates(@booking.start_date, @booking.end_date, @listing.id)
	        	redirect_to bookings_path
	      	else
	      		@errors = @booking.errors.full_messages
	        	redirect_to listings_path
	      	end
		else
			redirect_to '/sign_in', notice: 'You are not logged in' 
		end    
	end

	def show
		set_listing
		@booking = Booking.find(params[:id])
	end

	def edit
		set_listing
		@booking = Booking.find(params[:id])
	end

	private

	def booking_params
        processed_params = params.require(:booking).permit(:start_date, :end_date, :guest, :listing_id)
        processed_params[:start_date] = Date.strptime(processed_params[:start_date], "%m/%d/%Y")
        processed_params[:end_date] = Date.strptime(processed_params[:end_date], "%m/%d/%Y")
        return processed_params
    end

	def set_listing
        @listing = Listing.find(params[:listing_id])
    end

    def reserve_dates(start_date, end_date, listing_id)
    	dates_booked = (start_date..end_date).to_a
    	dates_booked.each do |date|
    		available_date = AvailableDate.new
    		available_date.booked_date = date
    		available_date.available = false
    		available_date.listing_id = listing_id
    		available_date.save
    	end	
    end

end
