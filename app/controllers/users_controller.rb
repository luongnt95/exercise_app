class UsersController < ApplicationController
	
	def index
		@users = Searcher.new(params).run
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

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(user_params)
			flash[:success] = "Update user successfully!"
			redirect_to users_url
		else
			render 'edit'
		end
	end

	def destroy
		@user = User.find(params[:id])
		
		if @user.avatar.exists?
			@user.avatar.destroy
		end
		redirect_to request.referrer
	end

	def bulk_action
		BulkAction.new(params).run
		redirect_to request.referrer || users_url
	end

	private

		def user_params
			params.require(:user).permit(:name, :email, :password, :avatar, :activated)
		end
end
