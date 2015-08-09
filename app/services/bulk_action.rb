class BulkAction

	def initialize(params)
		@params = params
		@All = GetModel.new(params[:controller]).run
		@collection = @All.all
	end

	def run
		if @params[:commit] == 'Activate'
			if collection = checked_items
				collection.each do |item|
					item.update_attribute(:activated, "activated")
				end
			end
		elsif @params[:commit] == 'Delete'
			if collection = checked_items
				collection.each do |item|
					item.update_attribute(:activated, "deactivated")
				end
			end
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