class Category < ActiveRecord::Base

	validates :name, presence: true
	validates :activated, inclusion: { :in => [true, false] }

end
