require_relative "empty_field_exception.rb"

class EmptyFielPasswordException < EmptyFieldException
	def initialize(data="EmptyFieldPasswordException(falta parametro password)")
		super(data)
	end
end
