class ListingsController < ApplicationController
	before_action :find_listing, only: [:show, :edit, :update, :destroy]

	def index
  		@filterrific = initialize_filterrific(
    	Listing,
    	params[:filterrific],
    	select_options: {
    		sorted_by: Listing.options_for_sorted_by,
    		with_country_id: Listing.countries_with_listings,
    		with_tag_ids: Tag.options_for_select
    	}
	  	) or return
	  	@listings = @filterrific.find

	  	respond_to do |format|
	    	format.html
	    	format.js
  		end
	end

	def new
		if signed_in?
			@listing = Listing.new
		else
			redirect_to '/sign_in', notice: 'You are not logged in' 
		end	
	end

	def create
		if signed_in? and current_user
			@listing = current_user.listings.create(listing_params)
			respond_to do |format|
				if @listing.save
		        	format.html { redirect_to @listing, notice: 'Listing was successfully created.' }
		      	else
		        	format.html { render :new }
		      	end
		    end
		else
			redirect_to '/sign_in', notice: 'You are not logged in' 
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
        params.require(:listing).permit(:title, :address, :price, :country_code, tag_ids: [], avatars: [])
    end


	def find_listing
        @listing = Listing.find(params[:id])
    end
end

  
