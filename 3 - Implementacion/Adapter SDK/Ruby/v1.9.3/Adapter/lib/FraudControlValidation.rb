require "json"

CONST_CSITPRODUCTDESCRIPTION = 'CSITPRODUCTDESCRIPTION'
CSBTSTATE = "CSBTSTATE"
NUMERAL = "#"	
FIELD = "field"
VALIDATE = "validate"
FORMAT = "format"
FUNCTION = "function"
MESSAGE = "message"
PARAMS = "params"
DEFAULT = "default"
MIN_LENGTH = 20
MAX_CHARS = 254
URL_VALIDATION_JSON	 = "../lib/config/validations.json"
URL_POSTALCODES_JSON = "../lib/config/postalCodes.json"
#########################################
# => Validation Class for Fraud Control
###########################################
class FraudControlValidation
#   @url       = "../validations.json"
#	@file      = File.read(@url)
#	@data_hash = JSON.parse(file)
	
	attr_accessor :data_hash , :postalcodes_hash, :csit_hash, :campError, :parameters

	def initialize()

		file_validations 	= File.read(URL_VALIDATION_JSON)
		@data_hash 			= JSON.parse(file_validations)	

		file_postalcodes 	= File.read(URL_POSTALCODES_JSON)
		@postalcodes_hash 	= JSON.parse(file_postalcodes)

		@csit_hash			= Hash.new
		@campError			= Hash.new
		@parameters 		= Hash.new
	end
	############################################################
	# => @boolean:  notEmpty => true , empty => false 
	############################################################
	def notEmpty(str)
		strResult = str.strip
		return ( strResult.length > 0 )? true:false
	end
	############################################################
	# => @string: clean special chars
	############################################################
	def clean(str)
		return str.gsub(/([.*+?^${}()|\[\]\/\\])/, '')
	end	
	############################################################
	# => @string: truncate string to @max characters 
	############################################################
	def truncate(str, max)
		lim = 0.. + max.to_i
		return str[lim]
	end	
	############################################################
	# => Hardcode value to set
	############################################################
	def hardcode(strHardCode)
		return strHardCode
	end	
	############################################################
	# => Generate random ID
	############################################################
	def random() 
		return (0...8).map { (1 + rand(9)) }.join
	end
	############################################################
	# => Validate with regular Expression
	############################################################
	def regex? (str, regExp)
		( str =~ '/\A('+ regExp + ')\Z/is' )==0
	end

	def email? (str)
		(str =~ /^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)*)\.([A-Za-z])+$/)==0
	end

	def ip? (str)
		(str =~ /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/)==0
	end	

	def totalAmount? (str)
		(str =~ /^([0-9]{0,12}).([0-9]{0,2})$/)==0
	end	
	
	def isBoolean? (str)
		(str =~ /^[YySsNn]$/)==0
	end	

	def phone? (str)	
		(str =~ /[0-9]/)==0
	end	

	def word? (str)
		(str =~ /[\w]/)==0
	end 
		
	def upper (str)
		return str.upcase  
	end

    def phoneSanitize ( phoneNumber )
    	phoneNumber = phoneNumber.gsub(' ', '')
	    phoneNumber = phoneNumber.gsub(/([+()-])/,'')
	    
	    if ( phoneNumber[0..1] == "54") 
	    	return phoneNumber
	    end
	    if ( phoneNumber[0..1] == "15")
	        phoneNumber = phoneNumber[2, phoneNumber.length]
	    end
	    if ( phoneNumber.length == 8 )  
	    	return "5411" + phoneNumber
	    end
	    if (phoneNumber[0] == "0" ) 
	    	return "54" + phoneNumber[1, phoneNumber.length]
	    end	
	    return "54" + phoneNumber
    end
    
	def findState ( field, strState )
		s = 'C'
		if (strState && (strState.strip != ''))
			s = strState[0]	
		elsif (!@parameters['CSBTSTATE'][0].nil? && (@parameters['CSBTSTATE'][0].strip != '') )
				s = @parameters['CSBTSTATE'][0]
		end	
		s = s.upcase

		return @postalcodes_hash[s]
	end

	############################################################
	# => Load csi Values into csiHash
	############################################################
	def loadCsit (field , value)
		@csit_hash[field] = value
		return value
	end 

	###########################################################################
	# => Min chars of ProductDescription = 20 
	# => If length > size , ommit lastest elements until adjust to given size
	###########################################################################
	def cutDescription(values, size) 
		result = ''
		arrayValues = Hash.new
		arrayValues = values.split(NUMERAL)
		aux = ''
		count = arrayValues.length
		x = (size / count) - 1
		
		if (x >= 20)
			arrayValues.each do |value|
				aux = truncate(value.strip, x) + NUMERAL
				result = result + aux
			end
		else 
			cantProduct = (size / 21)-1 
			for i in(0..cantProduct)
				aux = truncate(arrayValues[i].strip, (MIN_LENGTH - 1)) + NUMERAL
				result = result + aux
			end
		end  

		result = result[0, result.length - 1]

		return result
	end	

	def genericCutCsit(values, cant)
		result = ""
		arrayValues = values.split(NUMERAL)
		aux = '' 

		for i in(0..arrayValues.length)
			if (i < cant)
				aux = truncate(arrayValues[i].strip, (MIN_LENGTH - 1) ) + NUMERAL
				result = result + aux
			end
		end

		result = result[0, result.length - 1]

		return result
	end

	def addError(field, message) 
		
		if(self.campError[field].nil?)
			self.campError[field] = ' * ' + message
		else 
			self.campError[field] = self.campError[field] + ' * ' + message
		end
	end	

	############################################################
	# => Format csi Values into csiHash
	############################################################
	def csitFormat(size) 
		mapResult = Hash.new
		value = nil
		sizeDescription = 0

		if (!@csit_hash[CONST_CSITPRODUCTDESCRIPTION].nil?)

			value = @csit_hash[CONST_CSITPRODUCTDESCRIPTION]
			value = cutDescription(value, size)

			aux = value.split(NUMERAL) 
			sizeDescription = aux.length

			@csit_hash.each do |key , val|
				mapResult[key] = genericCutCsit(val, sizeDescription)
			end
		else
			addError(CONST_CSITPRODUCTDESCRIPTION , 'CSIT Product description está vacio')
		end

		return mapResult
	end
	############################################################
	# => main validation process 
	############################################################
	def validate (parameters)  
		@parameters = parameters
		resultMap = Hash.new
		begin
			parameters.each do |field , value|	
				resultMap[field]= self.validateAndFormat(field , value)
			end
			# csitformat elements from @csit_hash
			csitResult = csitFormat(254)
			csitResult.each do |field , value|	
				resultMap[field]= value
			end
			return resultMap
		rescue Exception=>e
		    e.message
		end 
 		
	end 	
	###
	# => get validate item from field
	###
	def getValidateItem(field) 
		item = nil
		@data_hash.each do |value|
			if (value['field']==field)
				item = value
				break
			end 
		end	
		return item
	end	
	############################################################
	# => Validation and format process for each field 
	############################################################
	def validateAndFormat(field , value)

		item = getValidateItem(field)

		# VALIDATE Value
		if (!item['validate'].nil? ) 			
			item['validate'].each do |elem|
				paramsValidate = Hash.new
				paramsValidate['str'] = value
				paramsValidate['field'] = field

				if (!elem['params'].nil? )
					paramsValidate['parameters'] = elem['params']
				end
					
				result =  self.executeFunction(elem['function'], paramsValidate )
				 
				# if is empty and required
				if (!result && (elem['function'] == 'notEmpty')  )
					if(item['required'])
						if (!elem['default'].nil? ) 
							value =  self.executeFunction(elem['default'], paramsValidate )
						elsif (!elem['message'].nil? )
							
							addError(field, elem['message'])
						else 
							addError(field, 'El valor de este campo esta vacio o es invalido')
						end		
					end	
				elsif (!result && (elem['function'] != 'notEmpty')  )
					if(item['required'])
						if (!elem['default'].nil? ) 
							value =  self.executeFunction(elem['default'], paramsValidate )
						elsif (!elem['message'].nil? )
							# 'notify field error'
							addError(field, elem['message'])
						else 
							addError(field, 'El valor de este campo esta vacio o es invalido')
						end		
					end		
				end	
				
			end
		end


		# FORMAT Value
		if (!item['format'].nil? )
			
			item['format'].each do |elem|

				paramsFormat = Hash.new
				paramsFormat['str'] = value
				if (!elem['params'].nil? ) 
					paramsFormat['parameters'] = elem['params']
				end	
				if (elem['function'] == 'csitFormat')
					paramsFormat['field'] = field
				end

				value = self.executeFunction(elem['function'], paramsFormat)
			 
				if (!elem['default'].nil? ) 
					value = self.executeFunction(elem['default'], paramsFormat )
				elsif (!elem['message'].nil? )
					# notify field error 
					addError(field, elem['message'])
				end
				
			end

		end

		return value

	end	
	############################################################
	# => Execute @functionName with @params and return result
	############################################################
	def executeFunction(functionName, params)
		case functionName
		when 'notEmpty'
			return self.notEmpty(params['str'])
		when 'clean'
			return self.clean(params['str'])
		when 'truncate'	
			return self.truncate(params['str'], params['parameters'][0])
		when 'hardcode'
			return self.hardcode(params['parameters'][0])
		when 'random'
			return self.random()
		when 'regex'
			#puts params['parameters'][0]
			return self.regex? params['str'], params['parameters'][0]
		when 'email'
			#puts params['parameters'][0]
			return self.email? params['str'].strip
		when 'ip'
			#puts params['parameters'][0]
			return self.ip? params['str'].strip	
		when 'totalAmount'
			#puts params['parameters'][0]
			return self.totalAmount? params['str'].strip	
		when 'boolean'
			#puts params['parameters'][0]
			return self.isBoolean? params['str'].strip
		when 'phone'
			#puts params['parameters'][0]
			return self.phone? params['str']
		when 'phoneSanitize'
			#puts params['parameters'][0]
			return self.phoneSanitize( params['str'] )	
		when 'word'
			return self.word? params['str'].strip
		when 'upper'	
			return self.upper( params['str'] )
		when 'findState'
			return self.findState( params['field'], params['str'] )	
		when 'csitFormat'
			return loadCsit( params['field'], params['str'])
		when 'N'
			return self.hardcode("N")
		when 'C'		
			return self.hardcode("C")
		else
			addError(functionName, 'no se encontro implementacion para este método ')
			return false
		end
	end

end












