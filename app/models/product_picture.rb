class ProductPicture < ActiveRecord::Base
	belongs_to :product

	has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

    validate :image_duplication

    def image_duplication
    	if product = Product.find_by(id: self.product_id)
            pictures = product.product_pictures
        	pictures.each do |pic|
        		errors.add(:image, " is duplicated!") if pic.image_file_name == self.image_file_name
        	end
        end
    end

end