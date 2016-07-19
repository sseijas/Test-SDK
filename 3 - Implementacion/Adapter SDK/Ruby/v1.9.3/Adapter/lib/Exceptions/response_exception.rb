class ResponseException < Exception
	def initialize(data="ResponseException(error en la respuesta)")
		super(data)
	end
end
