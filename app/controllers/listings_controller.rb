class ListingsController < ApplicationController
	before_action :find_listing, only: [:show, :edit, :update, :destroy]
	before_action :require_login,  only: [:new, :create, :update, :destroy, :my_listings]

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

	def search
		@results = Listing.search(params[:search_result])
	end	

	def new
		@listing = Listing.new
	end

	def create
		@listing = current_user.listings.create(listing_params)
		@listing.country_name = country_name
		@listing.save
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

	def my_listings
		@listings = current_user.listings
	end
		

	def listing_params
        params.require(:listing).permit(:title, :address, :price, :country_code, :remove_avatars, tag_ids: [], avatars: [])
    end


	def find_listing
        @listing = Listing.find(params[:id])
    end

    def country_name
    	country_name = ISO3166::Country[params[:listing][:country_code]].name
    end

    def require_login
		unless signed_in?
			flash[:alert] = "You must be logged in to access this section"
			redirect_to '/sign_in'
		end
	end

end

  
