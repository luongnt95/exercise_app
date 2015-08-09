class SessionsController < ApplicationController
	skip_before_action :logged_in_user
	
	def new
		redirect_to categories_url if logged_in?
	end

	def create
		user = User.find_by(name: params[:session][:name])
		if user && user.admin? && user.authenticate(params[:session][:password])
			log_in user
			remember user if params[:session][:remember_me] == '1'
			redirect_to categories_url
		else
			flash.now[:danger] = "Invalid name/password combination. Please log in again!"
			render 'new'
		end
	end

	def destroy
		if logged_in?
			flash[:success] = "Log out Succesfully"
			log_out
		end
		redirect_to root_url
	end
end
