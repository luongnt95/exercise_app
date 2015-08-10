class Category < ActiveRecord::Base

	VALID_TEXT_REGEX = /\A[a-zA-Z0-9\s+\.]+\z/
	validates :name, presence: true, length: { minimum: 2, maximum: 50 },
									 format: { with: VALID_TEXT_REGEX }

	validates :activated, presence: true, inclusion: { in: ["activated", "deactivated"] }

	def activated?
		return true if self.activated == "activated"
		return false
	end

	def self.search(search)
		if search
			where('id LIKE ? or name LIKE ? or activated LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
		else
			Category.all
		end
	end

end
