class Product < ActiveRecord::Base

	has_many :product_pictures
	validates :name, presence: true
	validates :price, presence: true
	validates :description, presence: true
	validates :activated, inclusion: { :in => [true, false] }

end
