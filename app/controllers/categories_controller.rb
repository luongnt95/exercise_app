class CategoriesController < ApplicationController

	def index
		@categories = Category.all
	end

	def new
		@category = Category.new
	end

	def create
		@category = Category.new(category_params)
		if @category.save
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
			redirect_to categories_path
		else
			render 'edit'
		end
	end

	def bulk_action
		commit = params[:commit]
		if commit == 'Activate'
			update_activates
			redirect_to categories_url
		elsif commit == 'Delete'
			delete_categories
			redirect_to categories_url
		end
	end

	private

		def category_params
			params.require(:category).permit(:name, :activated)
		end

		def delete_categories
			if params[:check_all] == '1'
				@categories = Category.all
			else
				@categories = Category.find(params[:category_ids])
			end
			@categories.each do |category|
				category.destroy
			end
		end

		def update_activates
			if params[:check_all] == '1'
				@categories = Category.all
			else
				@categories = Category.find(params[:category_ids])
			end
			@categories.each do |category|
				category.update_attribute(:activated, 'Activate')
			end
		end
end
