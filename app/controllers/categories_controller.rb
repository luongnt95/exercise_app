class CategoriesController < ApplicationController
 	helper_method :sort_column, :sort_direction

 	before_action :logged_in_user
 	
  	def index
    	@categories = Category.order(sort_column + ' ' + sort_direction)
    	@categories = @categories.paginate(page: params[:page], per_page: 5)
    	@total_pages = @categories.total_pages
    	@current_page = @categories.current_page
  	end
  	
	def new
		@category = Category.new
	end

	def create
		@category = Category.new(category_params)
		if @category.save
			flash[:success] = "Add category successfully "
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
			flash[:success] = 'Successfully update'
			redirect_to categories_path
		else
			render 'edit'
		end
	end

	def bulk_action
		commit = params[:commit]
		@categories = checked_categories(params[:current_page])
		if commit == 'Activate'
			@categories.each do |category|
				category.update_attribute(:activated, true)
			end
			redirect_to request.referrer || categories_url
		elsif commit == 'Delete'
			@categories.each do |category|
				category.update_attribute(:activated, false)
			end
			redirect_to request.referrer || categories_url
		end
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

  		def checked_categories(current_page)
  			if params[:check_all]
				@categories = Category.all.paginate(page: current_page, per_page: 5)
			elsif category_ids = params[:category_ids]
				@categories = Category.find(category_ids)
			end
  		end
end
