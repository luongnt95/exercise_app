class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  def raise_not_found
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end

  rescue_from ActiveRecord::RecordNotFound, with: :render_404 
  rescue_from ActionController::RoutingError, :with => :render_404
  rescue_from Exception, with: :render_404

  private

  	def logged_in_user
  		unless logged_in?
  			flash[:danger] = "Please log in."
  			redirect_to root_url
  	  end
    end

    def render_404
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    end
end
