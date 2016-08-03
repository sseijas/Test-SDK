require_relative "Exceptions/empty_field_exception"
require_relative "Exceptions/response_exception"
require 'json'
require 'rest-client'

TRANSACTION_ENDPOINT = 'http://localhost:8081/api/BSA/transaction'
DISCOVER_ENDPOINT 	 = 'http://localhost:8081/api/BSA/paymentMethod/discover'
LOGS_FILE = '../logs/logfile.log'
##########################################################################################
# => Billetera Stand Alone
##########################################################################################
class Bsa
	attr_accessor :logger, :attr_error

	def initialize()
		@logger = Logger.new(LOGS_FILE)
		@attr_error = Hash.new
	end	
	#####################################################
	# => Discover is an instance of Discover Class
	####################################################
	def discoverPaymentMethods(discover)
		begin
			responseJson = RestClient.get DISCOVER_ENDPOINT
    		discover.paymentMethods = JSON.parse(responseJson)
    		return discover
    	rescue Exception=>e
      		e.message
    	end
	end 
	
	#####################################################
	# => Transaction is an instance of Transaction Class
	####################################################
	def getTransactions(transaction)

		if(transaction.generalData==nil)
	  		raise EmptyFieldException.new
		end

		if (transaction.operationData==nil)
		  raise EmptyFieldException.new
		end

		# Make request 
		dataRequest = Hash.new
		dataRequest["generalData"]   = transaction.generalData
		dataRequest["operationData"] = transaction.operationData
		dataRequest["technicalData"] = transaction.technicalData

		# Validate Request 
		valid = self.validate(dataRequest , transaction.attr_required )
 
		if (valid)
			@logger.info('ENDPOINT:') { TRANSACTION_ENDPOINT }
			@logger.info('REQUEST:') { dataRequest }
			# Call method
			begin
				responseJson = RestClient.post TRANSACTION_ENDPOINT, dataRequest.to_json, :content_type => :json, :accept => :json
				@logger.info('RESPONSE:') { responseJson }
				transaction.response = JSON.parse(responseJson)
			rescue => e 
				@logger.info('RESPONSE error') { e.response }
				responseJson = e.response	
			end
				
		else 
			# If not valid, notify errors
			raise EmptyFieldException.new(@attr_error.to_json)
		end	

		return transaction
	end

	#####################################################
	# => Validate Transaction Data
	#####################################################
	def validate(data, attr_required)
        result = true
        # Merge input fields into array
		arr_att = Hash.new
		data['generalData'].each do |key, value|
    		arr_att[key] = value 
		end

		data['operationData'].each do |key, value|
    		arr_att[key] = value 
		end
		  
		# Now I notice if required fields are all positions
		attr_required.each do |key|
			if ( arr_att[key].nil? )
				@attr_error[key] = 'Este campo es requerido '
				result = false
			end
		end	

		return result 
	end	

end 