require 'savon'
require 'rest-client'
require 'json'

$versionTodoPago = '1.2.0'


$tenant = 't/1.1/'
$soapAppend = 'services/'
$restAppend = 'api/'

class TodoPagoConector
    # método inicializar clase
    def initialize(j_header_http, *args)#j_wsdl=nil, endpoint=nil, env=nil
        if args.length==2
            j_wsdls = args[0]
            endpoint = args[1]
        else args.length == 1
            j_wsdls = {
                    'Operations'=> '../lib/Operations.wsdl',
                    'Authorize'=> '../lib/Authorize.wsdl'
                    }
            if args[0]=="test"
                endpoint = 'https://developers.todopago.com.ar/'
            end
        end
        # atributos
        $j_header_http = j_header_http
        $j_wsdls = j_wsdls
        #hacer un if si es prod o test
        $endPoint = endpoint #recibe endpoint incompleto
    end

  ###########################################################################################
  #Methodo de clase que crea cliente que accede al servicio a través de SOAP utilizando savon
  ###########################################################################################
  def self.getClientSoap(wsdlService,sufijoEndpoint)
    return Savon.client(
        headers:$j_header_http,
        wsdl: wsdlService,
        endpoint: $endPoint + $soapAppend + $tenant +sufijoEndpoint,
        log: false,
        log_level: :debug,
        ssl_verify_mode: :none,
        convert_request_keys_to: :none)
  end

  def self.buildPayload(optionAuthorize)
    
    @xml = "<Request>"
    optionAuthorize.each do |item|
      @xml = @xml.concat("<")
                 .concat(item[0].to_s)
                 .concat(">")
                 .concat(item[1])
                 .concat("</")
                 .concat(item[0].to_s)
                 .concat(">")
    end
    @xml = @xml.concat("</Request>");
    return @xml;
  end
  ######################################################################################
  ###Methodo publico que llama a la primera funcion del servicio SendAuthorizeRequest###
  ######################################################################################
  def sendAuthorizeRequest(options_comercio, options_operacion)

      message = {Security: options_comercio[:security],
                 Merchant: options_comercio[:MERCHANT],
                 EncodingMethod: options_comercio[:EncodingMethod],
                 URL_OK: options_comercio[:URL_OK],
                 URL_ERROR: options_comercio[:URL_ERROR],
                 EMAILCLIENTE: options_comercio[:EMAILCLIENTE],
                 Session: options_comercio[:Session],
                 Payload: TodoPagoConector.buildPayload(options_operacion)};

      client = TodoPagoConector.getClientSoap($j_wsdls['Authorize'],'Authorize');
      response = client.call(:send_authorize_request, message: message)
      return response.hash
  end
  #####################################################################################
  ###Methodo publico que llama a la segunda funcion del servicio GetAuthorizeAnswer###
  #####################################################################################
  # <b>DEPRECATED:</b> Please use <tt>getAuthorizeAnswer</tt> instead.
  def getAuthorizeRequest(optionsAnwser)
    warn "[DEPRECATION] 'getAuthorizeRequest' is deprecated.  Please use 'getAuthorizeAnswer' instead."
    return getAuthorizeAnswer(optionsAnwser)
  end

  def getAuthorizeAnswer(optionsAnwser)
    message = {Security: optionsAnwser[:security],
               Merchant: optionsAnwser[:MERCHANT],
               RequestKey: optionsAnwser[:RequestKey],
               AnswerKey: optionsAnwser[:AnswerKey]};

    client = TodoPagoConector.getClientSoap($j_wsdls['Authorize'],'Authorize')
    response= client.call(:get_authorize_answer,message:message)
    return response.hash
  end

  ############################################################
  ###Methodo publico que retorna el status de una operacion###
  ############################################################
  def getOperations(optionsOperations)
    url = $endPoint + $tenant + $restAppend + 'Operations/GetByOperationId/MERCHANT/' + optionsOperations[:MERCHANT] + '/OPERATIONID/' + optionsOperations[:OPERATIONID]
    #url = $j_wsdls['Services'] + 'api/Operations/GetByOperationId/MERCHANT/' + optionsOperations[:MERCHANT] + '/OPERATIONID/' + optionsOperations[:OPERATIONID]
    xml = RestClient.get url
	return xml
  end
  ################################################################
  ###Methodo publico que descubre todas las promociones de pago###
  ################################################################
  def getAllPaymentMethods(optionsPaymentMethod)
    url = $endPoint + $tenant + $restAppend + 'PaymentMethods/Get/MERCHANT/' + optionsPaymentMethod[:MERCHANT]
  	#url = $j_wsdls['Services'] + 'api/PaymentMethods/Get/MERCHANT/' + optionsPaymentMethod[:MERCHANT]
  	xml = RestClient.get url
    return xml
  end
  
  ##############################################################################
  ###Methodo publico que descubre todas las operaciones en un rango de fechas###
  ##############################################################################
  ##$url = $this->end_point.TODOPAGO_ENDPOINT_TENATN.'api/Operations/GetByRangeDateTime/MERCHANT/'. $arr_datos["MERCHANT"] . '/STARTDATE/' . $arr_datos["STARTDATE"] . '/ENDDATE/' . $arr_datos["ENDDATE"] . '/PAGENUMBER/' . $arr_datos["PAGENUMBER"];
 
 def getByRangeDateTime(optionsAnswer)
    url = $endPoint + $tenant + $restAppend +"Operations/GetByRangeDateTime/MERCHANT/#{optionsAnswer[:Merchant]}/STARTDATE/#{optionsAnswer[:STARTDATE]}/ENDDATE/#{optionsAnswer[:ENDDATE]}/PAGENUMBER/#{optionsAnswer[:PAGENUMBER]}"         
    response = RestClient.get url
    return response
  end

  ##############################################################################
  ###Devolucion                                                              ###
  ##############################################################################

  def returnRequest(refoundOptions)
    message = {
      Security: refoundOptions[:Security],
      Merchant: refoundOptions[:Merchant],
      RequestKey: refoundOptions[:RequestKey],
      AMOUNT: refoundOptions[:AMOUNT]
    }

    client = TodoPagoConector.getClientSoap($j_wsdls['Authorize'], 'Authorize')
    response= client.call(:return_request, message:message)
    return response.hash
  end
  ########################################################################
  ### GETCREDENTIALS######################################################
  ########################################################################
  def getCredentials(user)
    url = $endPoint + $restAppend +"Credentials"
    response = RestClient.post url, user.getData.to_json, :content_type => :json
	response = JSON.parse(response)
	if response['Credentials']['resultado']['codigoResultado'] != 0
		raise ResponseException.new
	end
	user.merchant = response['Credentials']['merchantId']
	user.apiKey = response['Credentials']['APIKey']
	return user
  end

end
