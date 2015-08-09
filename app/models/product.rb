class Product < ActiveRecord::Base

	has_many :product_pictures
	VALID_TEXT_REGEX = /\A[a-zA-Z0-9\s+]+\z/
	validates :name, presence: true, length: { minimum: 2, maximum: 50 },
									 format: { with: VALID_TEXT_REGEX}
	validates :price, presence: true
	validates :description, presence: true
	validates :activated, inclusion: { in: ["activated", "deactivated"] }

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
