class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :sort_column, :sort_direction
  include SessionsHelper

  def raise_not_found
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end

  rescue_from ActiveRecord::RecordNotFound, with: :render_404 
  rescue_from ActionController::RoutingError, :with => :render_404
  rescue_from Exception, with: :render_404

  def sort_column
    get_model(self).column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end

  private

  	def logged_in_user
  		unless logged_in?
  			flash[:danger] = "Please log in."
  			redirect_to root_url
  	  end
    end

    def get_model(instance_name)
      if instance_name.class.name == "CategoriesController"
        return Category
      elsif instance_name.class.name == "ProductsController"
        return Product
      elsif instance_name.class.name == "UsersController"
        return User
      end
    end

    def render_404
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    end
end
