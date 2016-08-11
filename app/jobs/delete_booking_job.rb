class DeleteBookingJob < ActiveJob::Base
  queue_as :default

  def perform(booking)
    # Do something later
    if Payment.find_by(booking_id: booking.id) == nil
    	booking.destroy
    end
  end
end
