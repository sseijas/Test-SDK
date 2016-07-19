require_relative "empty_field_exception.rb"

class EmptyFieldUserException < EmptyFieldException
	def initialize(data="EmptyFieldUserException(falta parametro user)")
		super(data)
	end
end
