
class Transaction

	attr_accessor :generalData, :operationData, :technicalData, :response, :attr_required
	
	def initialize(generalData=nil, operationData=nil, technicalData=nil)
		@attr_required = [:merchant, :security, :operationDatetime, :remoteIpAddress, :channel, :operationID, :currencyCode, :amount]	
		@generalData   = generalData
		@operationData = operationData
		@technicalData = technicalData
	end

end

