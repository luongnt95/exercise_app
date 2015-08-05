class UsersController < ApplicationController

	before_action :logged_in_user
	
	def index
		@users = User.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: 5)
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
		commit = params[:commit]
		if @users = checked_users
			if commit == 'Activate'
				@users.each do |user|
					user.update_attribute(:activated, "activated")
					
				end

				flash[:success] = "Activate successfully!"
			elsif commit == 'Delete'
				@users.each do |user|
					user.update_attribute(:activated, "deactivated")
				end
				flash[:success] = "Deactivate successfully!"
			end
		end
		redirect_to request.referrer || users_url
	end

	private

		def user_params
			params.require(:user).permit(:name, :email, :password, :avatar, :activated)
		end

		def checked_users
			if params[:check_all]
				@users = User.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(page: params[:current_page], per_page: 5)
			elsif user_ids = params[:user_ids]
				@users = User.find(user_ids)
			end
		end
end
