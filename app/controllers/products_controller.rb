class ProductsController < ApplicationController

  before_action :logged_in_user
  
  def index
  	@products = Product.all
    @products = @products.paginate(page: params[:page], per_page: 5)
    @total_pages = @products.total_pages
    @current_page = @products.current_page
  end

  def show
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
      redirect_to products_path
  	else
  		render 'edit'
  	end
  end

  def bulk_action
    commit = params[:commit]
    if commit == 'Activate'
      update_activates
      redirect_to request.referrer || products_path
    elsif commit == 'Delete'
      delete_products
      redirect_to request.referrer || products_path
      
    end
  end

  private

  	def product_params
  		params.require(:product).permit(:name, :price, :description, :picture, :activated)
  	end

    def delete_products
      if products = checked_products
        products.each do |product|
          product.destroy
        end
      end
    end

    def update_activates
      if products = checked_products
        products.each do |product|
          product.update_attribute(:activated, true)
        end
      end
    end

    def checked_products
      if params[:check_all]
        @products = Product.all
      elsif product_ids = params[:product_ids]
        @products = Product.find(product_ids)
      end
    end
end
