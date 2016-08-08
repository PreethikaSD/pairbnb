class BookingMailer < ApplicationMailer
	default from: 'pairbnbmail@gmail.com'

	def booking_email(booking, listing)
		@customer = booking
		@host = listing
		@user = User.find(@customer.user_id)
		@url = "http://localhost:3000"
		mail(to: @user.email, subject: 'Your booking is confirmed')
	end

end
