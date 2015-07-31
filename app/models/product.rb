class Product < ActiveRecord::Base

	validates :activated, inclusion: { :in => [true, false] }

	def activation_status
		if self.activated?
			"Activated"
		else
			"Deactivated"
		end
	end

end
