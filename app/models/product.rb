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

	def self.search(search)
		if search
			where('id LIKE ? or name LIKE ? or price LIKE ? or activated LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
		else
			Product.all
		end
	end

end
