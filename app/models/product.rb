class Product < ActiveRecord::Base

	has_many :product_pictures
	
	validates :name, presence: true
	validates :price, presence: true
	validates :description, presence: true
	validates :activated, presence: true, inclusion: { in: ["activated", "deactivated"] }

	def activated?
		return true if self.activated == "activated"
		return false
	end

end
