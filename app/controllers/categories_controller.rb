class CategoriesController < ApplicationController
 	helper_method :sort_column, :sort_direction

 	# before_filter -> { check_action }
 	# before_filter -> { check_id }
 	# before_filter -> { check_controller }

 	# before_action :check_id, :check_controller, check_action

 	before_action :logged_in_user
 	

  	def index
    	@categories = Category.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: 5)
    	@total_pages = @categories.total_pages
    	@current_page = @categories.current_page
  	end

  	def show
  	end

	def new
		@category = Category.new
	end

	def create
		@category = Category.new(category_params)
		if @category.save
			flash[:success] = "Add category successfully!"
			redirect_to categories_url
		else
			render 'new'
		end
	end

	def edit
		@category = Category.find(params[:id])
	end

	def update
		@category = Category.find(params[:id])
		if @category.update_attributes(category_params)
			flash[:success] = 'Successfully update!'
			redirect_to categories_url
		else
			render 'edit'
		end
	end

	def bulk_action
		commit = params[:commit]
		if @categories = checked_categories
			if commit == 'Activate'
				@categories.each do |category|
					category.update_attribute(:activated, "activated")
				end
				flash[:success] = "Activate successfully!"
			elsif commit == 'Delete'
				@categories.each do |category|
					category.update_attribute(:activated, "deactivated")
				end
				flash[:success] = "Deactivate successfully!"
			end
		end
		redirect_to request.referrer || categories_url
	end

	private

		def category_params
			params.require(:category).permit(:name, :activated)
		end

		def sort_column
    		Category.column_names.include?(params[:sort]) ? params[:sort] : "id"
  		end
  
  		def sort_direction
    		%w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  		end

  		def checked_categories
  			if params[:check_all]
				@categories = Category.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(page: params[:current_page], per_page: 5)
			elsif category_ids = params[:category_ids]
				@categories = Category.find(category_ids)
			end
  		end
end
