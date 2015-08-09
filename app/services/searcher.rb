class Searcher
	PER_PAGE = 5

	def initialize(params)
		@params = params
		@All = GetModel.new(params[:controller]).run
	end

	def run
		str = @params[:search]

		unless str.nil?
			unless str.scan(/[0-9]/).join == ""
				str.gsub!(/\s+/, "")
				str = str.scan(/[0-9]/).join
			else
				str.gsub!(/\s+/, " ")
				str.strip!
			end
		end

		@collection = @All.search(str)
		@collection = @collection.order(@params[:sort] + ' ' + @params[:direction]) if @params[:sort]
		@collection = @collection.paginate(page: @params[:page], per_page: PER_PAGE)
	end

end