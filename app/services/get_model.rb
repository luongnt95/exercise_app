class GetModel
	def initialize(controller_type)
		@type = controller_type
	end

	def run
		if @type == "categories"
			return Category
		elsif @type == "products"
			return Product
		elsif @type == "users"
			return User
		end
	end
end