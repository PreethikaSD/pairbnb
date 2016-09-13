class UsersController < ApplicationController
	before_action :require_login,  only: [:index, :update, :show, :edit]

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
		@user.update(user_params)
		redirect_to @user
	end

	private

	def user_params
        params.require(:user).permit(:email, :password, :avatar, :remove_avatar)
    end

    def require_login
		unless signed_in?
			flash[:alert] = "You must be logged in to access this section"
			redirect_to '/sign_in'
		end
	end

end

