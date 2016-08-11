class PaymentsController < ApplicationController
  def new
  	@payment = Payment.new
  	@amount = calculate_amount
  	gon.client_token = generate_client_token
  end

  def create
    @result = Braintree::Transaction.sale(
   	amount: calculate_amount,
    payment_method_nonce: params[:payment_method_nonce])
    if @result.success?
    	current_user.payments.create(booking_id: params[:booking_id], paid: true, amount: calculate_amount, transaction_id: @result.transaction.id )
        redirect_to @booking, notice: "Congratulations! Your transaction has been successful!"
    else
      flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
      gon.client_token = generate_client_token
      @booking = Booking.find(params[:booking_id])
      render :new
    end
  end

  private
	def generate_client_token
		Braintree::ClientToken.generate
	end

  	def calculate_amount
  		if Booking.find(params[:booking_id])
  			@booking = Booking.find(params[:booking_id])	  	
		  	@listing = @booking.listing
		  	duration = (@booking.start_date..@booking.end_date).to_a.count
		  	duration * @listing.price
		else
		  	flash[:alert] = "Your booking is invalid. Please try again!"
		    redirect_to new_booking_payment_path(@booking)
		end 


  	end
end
