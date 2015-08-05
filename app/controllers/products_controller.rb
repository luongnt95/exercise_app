class ProductsController < ApplicationController

  before_action :logged_in_user
  
  def index
  	@products = Product.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: 5)
    @total_pages = @products.total_pages
    @current_page = @products.current_page
  end

  def new
  	@product = Product.new
  end

  def create
  	@product = Product.new(product_params)
  	if @product.save
      if images = params[:images]
        images.each do |image|
          @product.product_pictures.create(image: image)
        end
      end
      flash[:success] = "Add product successfully"
  		redirect_to products_path
  	else
  		render 'new'
  	end
  end

  def edit
  	@product = Product.find(params[:id])
    @pictures = @product.product_pictures
  end

  def update
  	@product = Product.find(params[:id])
  	if @product.update_attributes(product_params)
  		if images = params[:images]
        images.each do |image|
          @product.product_pictures.create(image: image)
        end
      end
      flash[:success] = "Update product successfully"
      redirect_to products_path
  	else
  		render 'edit'
  	end
  end

  def bulk_action
    commit = params[:commit]

    if @products = checked_products
      if commit == 'Activate'
        @products.each do |product|
          product.update_attribute(:activated, "activated")
        end
        flash[:success] = "Activate successfully!"
      elsif commit == 'Delete'
        @products.each do |product|
          product.update_attribute(:activated, "deactivated")
        end
        flash[:success] = "Deactivate successfully!"
      end
    end
    redirect_to request.referrer || products_url
  end

  private

  	def product_params
  		params.require(:product).permit(:name, :price, :description, :picture, :activated)
  	end

    def checked_products
      if params[:check_all]
        @products = Product.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(page: params[:current_page], per_page: 5)
      elsif product_ids = params[:product_ids]
        @products = Product.find(product_ids)
      end
    end
end
