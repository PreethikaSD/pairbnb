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
				#BookingMailer.booking_email(@booking, @listing).deliver_later
				#DeleteBookingJob.perform_in(1.minutes.from_now, @booking)
				DeleteBookingJob.set(wait: 1.minutes).perform_later(@booking)
				MailJob.perform_later(@booking, @listing)
				reserve_dates(@booking.start_date, @booking.end_date, @listing.id)
	        	redirect_to new_booking_payment_path(@booking)
	      	else
	      		@errors = @booking.errors.full_messages
	        	redirect_to listings_path
	      	end
		else
			redirect_to '/sign_in', notice: 'You are not logged in' 
		end    
	end

	def show
		@booking = Booking.find(params[:id])
	end

	def edit
		set_listing
		@booking = Booking.find(params[:id])
	end

	def destroy
		@booking = Booking.find(params[:id])
		@booking.destroy
    	respond_to do |format|
      		format.html { redirect_to listings_url, notice: 'Booking was successfully destroyed.' }
    	end
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
