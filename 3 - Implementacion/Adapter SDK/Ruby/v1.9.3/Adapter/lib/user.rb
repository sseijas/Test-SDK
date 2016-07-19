require_relative "Exceptions/empty_field_user_exception"
require_relative "Exceptions/empty_field_password_exception"

class User
  
  attr_accessor :merchant, :apiKey
  attr_reader :user, :password

  def initialize(user=nil, password=nil)
  	@user= user
	@password= password
  end

  def getData
	if(@user==nil)
	  raise EmptyFieldUserException.new
	end

	if (@password==nil)
	  raise EmptyFieldPasswordException.new
	end

	data = {:USUARIO=>@user, :CLAVE=>@password}
	return data
  end

end

