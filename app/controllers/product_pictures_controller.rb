class ProductPicturesController < ApplicationController

  def destroy
  	@pic = ProductPicture.find_by(id: params[:id])
  	@pic.delete
  	redirect_to request.referrer || root_url
  end
end
