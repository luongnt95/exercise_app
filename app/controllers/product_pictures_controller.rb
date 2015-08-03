class ProductPicturesController < ApplicationController
  
  before_action :logged_in_user, only: [:destroy]

  def destroy
  	@pic = ProductPicture.find_by(id: params[:id])
  	@pic.delete
  	redirect_to request.referrer || root_url
  end
end
