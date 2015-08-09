class CategoriesController < ApplicationController
 	# before_filter -> { check_action }
 	# before_filter -> { check_id }
 	# before_filter -> { check_controller }

 	# before_action :check_id, :check_controller, check_action
 	

  	def index
    	@categories = Searcher.new(params).run
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
			flash[:success] = 'Update category successfully!'
			redirect_to categories_url
		else
			render 'edit'
		end
	end

	def bulk_action
		BulkAction.new(params).run
		redirect_to request.referrer || categories_url
	end

	private

		def category_params
			params.require(:category).permit(:name, :activated)
		end
  		
end
