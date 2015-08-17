class BulkAction

	def initialize(params)
		@params = params
		@All = GetModel.new(params[:controller]).run
		@collection = @All.all
	end

	def run
		if collection = checked_items
			if @params[:commit] == 'Activate'
				collection.each do |item|
					item.update_attribute(:activated, "activated")
				end
			elsif @params[:commit] == 'Delete'
				collection.each do |item|
					item.update_attribute(:activated, "deactivated")
				end
			end
			return true
		end
	end

	private

		def checked_items
			if @params[:check_all]
				Searcher.new(@params).run
			elsif ids = @params[:ids]
				@All.find(ids)
			end
		end

end