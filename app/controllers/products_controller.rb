class ProductsController < ApplicationController
  
  def index
  	@products = Searcher.new(params).run
  end

  def new
  	@product = Product.new
  end

  def create
  	@product = Product.new(product_params)
    if attributes_valid?
      @product.save
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
    @product = Product.new(product_params)
    if images_valid? && @product.valid?
      @product = Product.find(params[:id])
      @product.update_attributes(product_params)
      params[:images].each do |image|
        @product.product_pictures.create(image: image)
      end
      redirect_to products_path
    else
      render 'edit'
    end
  end

  def bulk_action
    BulkAction.new(params).run
    redirect_to request.referrer || products_url
  end

  private

  	def product_params
  		params.require(:product).permit(:name, :price, :description, :picture, :activated)
  	end

    def images_valid?
      check = true
      if images = params[:images]
        images.each do |image|
          check = false unless @product.product_pictures.build(image: image).valid?
        end
      end
      check
    end

    def attributes_valid?
      check = true
      check = false unless @product.valid?
      check = false unless images_valid?
      check
    end
end
