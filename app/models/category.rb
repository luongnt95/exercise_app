class Category < ActiveRecord::Base

	validates :name, presence: true
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
