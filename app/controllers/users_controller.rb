class UsersController < ApplicationController

	def index
		@users = User.all
	end
	
	def show
		@user = User.find(params[:id])
	end

	def edit
		@user = User.find(params[:id])
	end

	def create
	end	

	def update
		@user = User.find(params[:id])
		@user.email = params[:user][:email]
		@user.save
		redirect_to "/"
	end
end

