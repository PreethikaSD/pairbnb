class ListingsController < ApplicationController
	before_action :find_listing, only: [:show, :edit, :update, :destroy]

	def index
		@listings = Listing.all
	end

	def new
		@listing = Listing.new
	end

	def create
		@listing = current_user.listings.create(listing_params)
		respond_to do |format|
			if @listing.save
	        	format.html { redirect_to @listing, notice: 'Listing was successfully created.' }
	      	else
	        	format.html { render :new }
	      	end
	    end
	end
	
	def edit
	
	end	

	def show
	end

	def update
		respond_to do |format|
      		if @listing.update(listing_params)
        		format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
      		else
        		format.html { render :edit }
      		end
    	end
	end

	def destroy
		@listing.destroy
    	respond_to do |format|
      		format.html { redirect_to listings_url, notice: 'listing was successfully destroyed.' }
    	end
	end

	private

	def listing_params
        params.require(:listing).permit(:title, :address, :price)
    end


	def find_listing
        @listing = Listing.find(params[:id])
    end
end

  
