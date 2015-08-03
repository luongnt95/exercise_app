class ProductPicture < ActiveRecord::Base
	belongs_to :product

	has_attached_file :image, 
					   styles: { large: "600x600>", medium: "400x400>", thumb: "150x150>" },
	   				   :path => ":rails_root/public/images/:id/:filename",
    				   :url  => "/images/:id/:filename"
    do_not_validate_attachment_file_type :image
end