class UsersController < ApplicationController

	before_action :logged_in_user
	
	def index
		@users = User.all
		@users = @users.paginate(page: params[:page], per_page: 5)
		@total_pages = @users.total_pages
    	@current_page = @users.current_page
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			redirect_to users_url
		else
			render 'new'
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	private

		def user_params
			params.require(:user).permit(:name, :email, :password, :avatar, :activated)
		end
end
