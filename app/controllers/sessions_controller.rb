class SessionsController < ApplicationController

	def new
		redirect_to categories_url if logged_in?
	end

	def create
		user = User.find_by(name: params[:session][:name])
		if user && user.authenticate(params[:session][:password])
			log_in user
			remember user if params[:session][:remember_me] == '1'
			redirect_to categories_url
		else
			flash.now[:danger] = "Invalid name/password combination. Please log in again!"
			render 'new'
		end
	end

	def destroy
		log_out if logged_in?
		redirect_to root_url
	end
end
