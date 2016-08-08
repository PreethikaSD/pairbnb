class MailJob < ActiveJob::Base
  queue_as :default

  def perform(booking, listing)
    # Do something later
    BookingMailer.booking_email(booking, listing).deliver

  end
end
