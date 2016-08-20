require 'rails_helper'
require 'byebug'
RSpec.describe ListingsController, type: :controller do

	let(:user) {FactoryGirl.create(:user)}
	let(:listing) {FactoryGirl.create(:listing)}
	let(:valid_params) {FactoryGirl.attributes_for(:listing)}

	before(:each) {sign_in_as user}
	describe '#index' do

		it 'gets all the listings' do
			get :index
			expect(assigns(:listings)).to match_array Listing.all
		end
	end

	describe '#create' do
		context 'with valid params' do
			it 'will create listing' do
				post :create, listing: valid_params
				expect(Listing.all.count).to eq 1
			end
		end
	end	

	describe "#show" do
		context 'displays the show page' do
			it 'will go to listings show page' do
				get :index, id: listing.id 
				expect(response).to have_http_status(:success)
			end
		end
	end		

	describe "#edit" do
	    it "returns http success" do
	        get :edit, id: listing.id
	        expect(response).to have_http_status(:success)
	    end
  	end
end




