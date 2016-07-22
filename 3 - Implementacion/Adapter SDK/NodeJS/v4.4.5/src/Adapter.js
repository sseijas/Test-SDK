//Adapter.js
const path = require("path");
const fs   = require("fs");
const util = require("util");
const sdk =  require("../lib/todo-pago.js");
var deasync = require('deasync');

//The authorization key
const	Authorization = "Authorization";

//The security key
const	Security = "Security";

//The session key
const	Session = "Session";

//The merchant key
const	Merchant = "Merchant";

//The Request key
const	RequestKey = "RequestKey";

//The public request  key
const	PublicRequestKey = "PublicRequestKey";

//The Answer key
const	AnswerKey = "AnswerKey";

//The url for ok
const	UrlOk = "URL_OK";

//The url for error
const	UrlError = "URL_ERROR";

//The encoding method
const	EncodingMethod = "EncodingMethod";

//The payment End Point
const	PaymentEndPoint = "PaymentEndPoint";

//The operation Id
const	OperationId = "OPERATIONID";

//The Currency Code
const	CurrencyCode = "CURRENCYCODE";

//The amount value
const	Amount = "AMOUNT";

//The email client
const	EmailCliente = "EMAILCLIENTE";

//The CSBT City
const	CsbtCity = "CSBTCITY";

//The CSBT Country
const	CsbtCountry = "CSBTCOUNTRY";

//The CSBT Email
const	CsbtEmail = "CSBTEMAIL";

//The CSBT First Name
const	CsbtFirstName = "CSBTFIRSTNAME";

//The CSBT Last Name
const	CsbtLastName = "CSBTLASTNAME";

//The CSBT Phone Number
const	CsbtPhoneNumber = "CSBTPHONENUMBER";

//The CSBT Postal Code
const	CsbtPostalCode = "CSBTPOSTALCODE";

//The CSBT State
const	CsbtState = "CSBTSTATE";

//The CSBT Street 1
const	CsbtStreet1 = "CSBTSTREET1";

//The CSBT Street 2
const	CsbtStreet2 = "CSBTSTREET2";

//The CSBT Customer Id
const	CsbtCustomerId = "CSBTCUSTOMERID";

//The CSBT IP Address
const	CsbtIpAddress = "CSBTIPADDRESS";

//The CSPT currency
const	CsptCurrency = "CSPTCURRENCY";

//The CSPT Grand Total Amount
const	CsptGrandTotalAmount = "CSPTGRANDTOTALAMOUNT";

//The CSMDD 6
const	Csmdd6 = "CSMDD6";

//The CSMDD 7
const	Csmdd7 = "CSMDD7";

//The CSMDD 8
const	Csmdd8 = "CSMDD8";

//The CSMDD 9
const	Csmdd9 = "CSMDD9";

//The CSMDD 10
const	Csmdd10 = "CSMDD10";

//The CSMDD 11
const	Csmdd11 = "CSMDD11";

//The CSST City
const	CsstCity = "CSSTCITY";

//The CSST Country
const	CsstCountry = "CSSTCOUNTRY";

//The CSST Email
const	CsstEmail = "CSSTEMAIL";

//The CSST First Name
const	CsstFirstName = "CSSTFIRSTNAME";

//The CSST Last Name
const	CsstLastName = "CSSTLASTNAME";

//The CSST Phone Number
const	CsstPhoneNumber = "CSSTPHONENUMBER";

//The CSST Postal Code
const	CsstPostalCode = "CSSTPOSTALCODE";

//The CSST State
const	CsstState = "CSSTSTATE";

//The CSST Street 1
const	CsstStreet1 = "CSSTSTREET1";

//The CSST Street 2
const	CsstStreet2 = "CSSTSTREET2";

//The CSIT Product Code
const	CsitProductCode = "CSITPRODUCTCODE";

//The CSIT Product Description
const	CsitProductDescription = "CSITPRODUCTDESCRIPTION";

//The CSIT Product Name
const	CsitProductName = "CSITPRODUCTNAME";

//The CSIT Product SKU
const	CsitProductSku = "CSITPRODUCTSKU";

//The CSIT Total Amount
const	CsitTotalAmount = "CSITTOTALAMOUNT";

//The CSIT Quantity
const	CsitQuantity = "CSITQUANTITY";

//The CSIT Unit Price
const	CsitUnitPrice = "CSITUNITPRICE";

//The CSMD 12
const	Csmdd12 = "CSMDD12";

//The CSMD 13
const	Csmdd13 = "CSMDD13";

//The CSMD 14
const	Csmdd14 = "CSMDD14";

//The CSMD 15
const	Csmdd15 = "CSMDD15";

//The CSMD 16
const	Csmdd16 = "CSMDD16";

//Scritp instance parameters
var inputPath = "";
var outputPath = "";
var xmlPath = "";
var command = "";

//Scritp instance constants
const PAYMENT_FLOW = "PaymentFlow";

const SEND_REQUEST = "SendAuthorizeRequest";

const GET_ANSWER = "GetAuthorizeAnswer";

const GET_STATUS = "GetStatus";

const AVAILABLE_COMMANDS = [ PAYMENT_FLOW, SEND_REQUEST, GET_ANSWER, GET_STATUS];

const CONFIGURATION_EXCEPTION = 100;

const FIELDNOTFOUND_EXCEPTION = 200;

//Log functions
function logError(message){
	console.error("ERROR:" + message);	
}

function logInfo(message){
	console.info("INFO:" + message);	
}

function logTitle(message){
	console.info(message.toUpperCase());	
}

//EvaluateParameters
function evaluateParameters(args){    
	for (var i = 0; i < args.length; i++){
		  var val = args[i];

			if (val == "/?"){
					console.info("Usage mode: >node Adapter.js /c:{command} /i:{Path and file} /o:{Path and file} /x:{Path and File}");
					console.info("Where:");
					console.info("/c: The command name, must be one of following: " + AVAILABLE_COMMANDS.join())
					console.info("/i: Path and filename for input file (command's parameters values file)");
					console.info("/o: Path and filename for output file (command's response file)");
					console.info("/x: Path and filename for xml payment service, required for [" + PAYMENT_FLOW + "] command")
					return 0;					
			}

			if (val.substring(0,3).toUpperCase() == "/C:"){
				command = val.substring(3);
				if (AVAILABLE_COMMANDS.indexOf(command)< 0){
					throw { message: util.format("Command [%s] is unrecognized.", command), code:  CONFIGURATION_EXCEPTION };
				}
			}		
		
			if (val.substring(0,3).toUpperCase() == "/I:"){
				inputPath = val.substring(3);
				inputPath = path.resolve(__dirname, inputPath).normalize();
				try {
					fs.statSync(inputPath);
				} catch (err){
					throw { message: util.format("File [%s] not found.", inputPath), code:  CONFIGURATION_EXCEPTION };
				}
			}
			
			if (val.substring(0,3).toUpperCase() == "/O:"){
				outputPath = val.substring(3);
				outputPath = path.resolve(__dirname, outputPath).normalize();
				try {
					var dirPath = path.dirname(outputPath);
					fs.statSync(dirPath);
				} catch (err){
					throw { message: util.format("Path [%s] not found.", outputPath), code:  CONFIGURATION_EXCEPTION };
				}
			}

			if (val.substring(0,3).toUpperCase() == "/X:"){
				xmlPath = val.substring(3);
				xmlPath = path.resolve(__dirname, xmlPath).normalize();
				try {
					fs.statSync(xmlPath);
				} catch (err){
					throw { message: util.format("File [%s] not found.", xmlPath), code:  CONFIGURATION_EXCEPTION };
				}
			}
	}
	
	if (command == ""){
		throw { message: "Command wasn't been configured, execute with /? for more information", code:  CONFIGURATION_EXCEPTION };
	}

  if (inputPath == ""){
  	throw { message: "InputPath wasn't been configured, execute with /? for more information", code:  CONFIGURATION_EXCEPTION };
  }	

  if (outputPath == ""){
  	throw { message: "OutputPath wasn't been configured, execute with /? for more information", code:  CONFIGURATION_EXCEPTION };
  }	
  if (xmlPath == "" && command == PAYMENT_FLOW){
  	throw { message: "XmlPath wasn't been configured, execute with /? for more information", code:  CONFIGURATION_EXCEPTION };
  }			
  
	return 1;
}

function loadParameters() {	
  var parameters = [];	
  var data = fs.readFileSync(inputPath).toString();
	var lines = data.split("\n");
	
	for (var i = 0; i < lines.length; i++){
		var line = lines[i];
		var values = line.split("=");
		if (line != "" && line.substring(0,4).indexOf("//")<0 && values.length ==2){

			var key = values[0].trim();
			if (key == "URL OK"){
				key = "URL_OK";
			}			
			if (key == "URL Error"){
				key = "URL_ERROR";
			}

			if (key == "Encoding Method"){
				key = "EncodingMethod";
			}

			var value = values[1].trim();
			if (value == "null"){
				value = "";
			}
			parameters[key] = value;			
		} 
	}

	logInfo(util.format("Parameters from [%s] loaded.", inputPath));
	return parameters;
}

function executeCommand(message) {
	
	var options = {
			endpoint : "developers",	
			Authorization : message["Authorization"]
	};

	var res;  

	if (command == PAYMENT_FLOW){
	
	}
	
	if (command == SEND_REQUEST){
		res = executeSendAuthorizeRequest(message, options);
	}
	
	if (command == GET_ANSWER){
	
	}
	
	if (command == GET_STATUS){
	
	}	
	logInfo("Command [" + command +  "] has been executed.");
	return res;
}

function executeSendAuthorizeRequest(parameters, options){

	request = fillDictionary(parameters, 
            [Security, 
             Session, 
             Merchant, 
             UrlOk, 
             UrlError, 
             EncodingMethod,
             OperationId,
             CurrencyCode,
             Amount]);
    request[Merchant.toUpperCase()] = parameters[Merchant];

	payload = fillDictionary( parameters,
			[EmailCliente,
            CsbtCity,
            CsbtCountry,
            CsbtEmail,
            CsbtFirstName,
            CsbtLastName,
            CsbtPhoneNumber,
            CsbtPostalCode,
            CsbtState,
            CsbtStreet1,
            CsbtStreet2,
            CsbtCustomerId,
            CsbtIpAddress,
            CsptCurrency,
            CsptGrandTotalAmount,
            Csmdd6,
            Csmdd7,
            Csmdd8,
            Csmdd9,
            Csmdd10,
            Csmdd11,
            CsstCity,
            CsstCountry,
            CsstEmail,
            CsstFirstName,
            CsstLastName,
            CsstPhoneNumber,
            CsstPostalCode,
            CsstState,
            CsstStreet1,
            CsstStreet2,
            CsitProductCode,
            CsitProductDescription,
            CsitProductName,
            CsitProductSku,
            CsitTotalAmount,
            CsitQuantity,
            CsitUnitPrice,
            Csmdd12,
            Csmdd13,
            Csmdd14,
            Csmdd15,
            Csmdd16])	

	var done = true;
	var response;
	sdk.sendAutorizeRequest(options, request, payload, function(result, err){

		if (err) {
			throw err;
		}
		
		parameters[RequestKey] = result[RequestKey];
		parameters[PublicRequestKey] = result[PublicRequestKey];
		done = true;
		response = result;
	});

	deasync.loopWhile(function(){return !done;});

	return response;
}

function executeGetAuthorizeAnswer(message, options){
}

function executeGetStatus(message, options){
}

function executePaymentService(message){
}

function fillDictionary(parameters, fields){
	res = [];
	
	for (var i = 0; i < fields.length; i++){
  	try {
  		res[fields[i]] = parameters[fields[i]];
  	} catch (err){
			throw { message: util.format("Field [%s] wasn't been provided in data file.", fields[i]), code:  FIELDNOTFOUND_EXCEPTION };  		
  	}  	
  }	
  return res;
}

function writeResponse(message, options, nextsSteps){
	var buffer = writeDictionary(message);
	
	fs.writeFile(outputPath, buffer, function(err) {
		if(err) {
			throw err;
		}
		logInfo("File [" + outputPath +"] has been written.")
	}); 
}

function writeDictionary(message){
	var buffer = "";	

	if (typeof message != 'undefined'){
		Object.keys(message).forEach(function(key) {
			var value = message[key];  	  	

			if (typeof value == "object") {  		  		
				buffer = buffer + "******************" + key + "****************************\n";
				buffer = buffer + writeDictionary(value);
				buffer = buffer + "\n";
				
			} else {
				buffer = buffer + key + "=" + value + "\n";  		
			}
		});
	}
	return buffer;
}

//Main entry point
try {
	
	if (evaluateParameters(process.argv) == 1) {		  
		  	  writeResponse(
		  	  	executeCommand(
		  	  		loadParameters()
		  	  	)
		  	  );
	}
		
} catch (err){	
	if (err.code == CONFIGURATION_EXCEPTION || err.code == FIELDNOTFOUND_EXCEPTION) {
		logError(err.message);	
	} else {		
		console.error (err.stack);
	} 
}

