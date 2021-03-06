class User < ActiveRecord::Base
	attr_accessor :remember_token
	VALID_TEXT_REGEX = /\A[a-zA-Z0-9\s+\.\-]+\z/
	validates :name, presence: true, length: { minimum: 2, maximum: 50 },
									 format: { with: VALID_TEXT_REGEX}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
									  format: { with: VALID_EMAIL_REGEX }

	validates :activated, presence: true, inclusion: { in: ['activated', 'deactivated'] }

	has_secure_password
	validates :password, length: { minimum: 6 }, allow_nil: true

	has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, 
					  :default_url => "/images/thumb/defalt_thumb/:style.jpg"
	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

	#validate :avatar_duplication

	#def avatar_duplication
	#	if user = User.find_by(id: self.id)
	#		errors.add(:avatar, "is already there!") if user.avatar_file_name == self.avatar_file_name
	#	end
	#end

	def activated?
		return true if self.activated == "activated"
		return false
	end

	def self.search(search)
		if search
			where('id LIKE ? or name LIKE ? or activated LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
		else
			User.all
		end
	end

	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  	  BCrypt::Engine.cost
     	BCrypt::Password.create(string, cost: cost)
  	end

	def User.new_token
		SecureRandom.urlsafe_base64
	end

	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	def forget
		update_attribute(:remember_digest, nil)
	end

end
