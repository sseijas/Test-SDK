#log
import sys
import os
import os.path
import traceback
import httplib, urllib
import requests

from suds.sudsobject import asdict

#path to Python SDK
sys.path = ['..\lib'] + sys.path

from todopagoconnector import TodoPagoConnector

try:
	from Tkinter import *
except ImportError:
	from tkinter import *

try:
	import ttk
except ImportError:
	import tkinter.ttk as ttk

#logs functions
def logError(message):
	print("ERROR: " + message)

def logInfo(message):
	print("INFO:" + message)	

def logTitle(message):
	print(message.upper())	

#ConfigurationException
class ConfigurationException(Exception):
	def __init__( self, message ):
		self.message = message
		Exception.__init__(self, message) 

#FieldNotFoundException
class FieldNotFoundException(Exception):
	def __init__( self, message ):
		self.message = message
		Exception.__init__(self, message) 

#NoAnswerKeyException
class NoResponseKeyException(Exception):
	def __init__( self, message, context):
		self.message = message
		self.context = context
		Exception.__init__(self, message) 	

#main class Program
class Program:
	#Gets or sets the input path
	inputPath = ""
	#Gets or sets the output path
	outputPath = ""

	#Gets or sets the command
	command = ""

	#Gets or sets the xml Path for PaymentFlow command
	xmlPath = ""

	#The Send authorize request method
	sendRequest = "SendAuthorizeRequest"

	#The Get authorize Answer
	getAnswer = "GetAuthorizeAnswer"

	#The Get authorize Answer
	getStatus = "GetStatus"

	#The payment flow complete 
	paymentFlow = "PaymentFlow"

	#The list of available commands
	availableCommands = [sendRequest,getAnswer,getStatus,paymentFlow]

	#Evaluates and fills the program's parameter
	#param name="args":The array of arguments:
	#     For /SendAuthorizeRequest: c:SendAuthorizeRequest /i:.\Samples\Sample_01_SendRequest.ini /o:.\Samples\Sample_01_SendRequest.out
	#     For Payment flow: /c:PaymentFlow /i:.\Samples\Sample_01_PaymentFlow.ini /o:.\Samples\Sample_01_PaymentFlow.out /x:.\Samples\WS_Execute_Request.xml
	#returns: <b>True</b> if continue, <b>false</b> otherwise</returns>
	def evaluateParameters(self, params):
		eval = 1
		for i in range(0, len(params)):		
			if params[i] == "/?":
				eval = 0
				print("Usage mode: >Adapter /c:{command} /i:{Path and file} /o:{Path and file} /x:{Path and File}")
				print("Where:")
				print("/c: The command name, must be one of following: " + "".join( e + "," for e in self.availableCommands))
				print("/i: Path and filename for input file (command's parameters values file)")
				print("/o: Path and filename for output file (command's response file)")
				print("/x: Path and filename for xml payment service, required for [" + self.paymentFlow + "] command")

			if params[i][:3].upper() == "/C:":
				self.command = params[i][3:]
				if not self.command in self.availableCommands:
					raise ConfigurationException("Command [%s] is unrecognized." % self.command)
			
			if params[i][:3].upper() == "/I:":
				self.inputPath = params[i][3:]
				self.inputPath = os.path.join(os.getcwd(), self.inputPath)
				if not os.path.isfile(self.inputPath):
					raise ConfigurationException("File [%s] not found." % self.inputPath)

			if params[i][:3].upper() == "/O:":
				self.outputPath = params[i][3:]
				self.outputPath = os.path.join(os.getcwd(), self.outputPath)
				if not os.path.isdir(os.path.dirname(self.outputPath)):
					raise ConfigurationException("Path [%s] not found." % os.path.dirname(self.outputPath))

			if params[i][:3].upper() == "/X:":
				self.xmlPath = params[i][3:]
				self.xmlPath = os.path.join(os.getcwd(), self.xmlPath)
				if not os.path.isfile(self.xmlPath):
					raise ConfigurationException("File [%s] not found." % self.xmlPath)

		if self.command == "":
			raise ConfigurationException("Command wasn't configured, execute with /? for more information")

		if self.inputPath == "":
			raise ConfigurationException("InputPath wasn't configured, execute with /? for more information")

		if self.outputPath == "":
			raise ConfigurationException("OutputPath wasn't configured, execute with /? for more information")

		if self.xmlPath == "" and self.command == self.paymentFlow:
			raise ConfigurationException("XmlPath wasn't configured, execute with /? for more information")
		
		logInfo("Configuration completed.")
		return eval

	def loadParameters(self):
		parameters = {}
		with open(self.inputPath) as f:
			lines = f.readlines()

		for line in lines:
			if not line.strip() == "" and not line[:2] == "//":
				values = line.split("=")
				name = values[0].strip()
				if name == "URL OK":
					name = "URL_OK"

				if name == "URL Error":
					name = "URL_ERROR"

				if name == "Encoding Method":
					name = "EncodingMethod"

				value = values[1].strip()
				if value == "null":					
					value = ""

				parameters[name] = value 

		logInfo("File [%s] has been loaded." % self.inputPath)
		return parameters

	def writeResponse(self, message):
		f = open(self.outputPath,"w")
		self.writeDictionary(message, f)
		f.close()
		logInfo("File [%s] has been wroten." % self.outputPath)

	
	def writeDictionary(self, message, f):	
		for key, value in message.iteritems():
			if isinstance(value, dict):
				f.write("******************" + key + "****************************\n")
				self.writeDictionary(value, f)
				f.write("\n")
			else:	
				f.write(key + "=" + str(value) + "\n")

	def executeCommand(self, message):
		sdk = SkdServices()
		conn = sdk.initConnector(message)
		response = {}

		if self.command == self.sendRequest:
			response = sdk.executeSendAuthorizeRequest(message, conn)

		if self.command == self.getAnswer:
			response = sdk.executeGetAuthorizeAnswer(message, conn)

		if self.command == self.getStatus:
			response = sdk.executeGetStatus(message, conn)

		if self.command == self.paymentFlow:
			response[self.sendRequest] = sdk.executeSendAuthorizeRequest(message, conn)
			response[self.paymentFlow] = sdk.executePaymentService(message, self.xmlPath)
			response[self.getAnswer] = sdk.executeGetAuthorizeAnswer(message, conn)

		logInfo("Command [%s] has been executed." % self.command)
		return response

class SkdServices:

	# The service End point
	EndPoint = "EndPoint"

	# The authorization key
	Authorization = "Authorization"

	# The security key
	Security = "Security"

	#The session key
	Session = "Session"

	# The merchant key
	Merchant = "Merchant"

	# The Request key
	RequestKey = "RequestKey"

	# The public request  key
	PublicRequestKey = "PublicRequestKey"

	# The Answer key
	AnswerKey = "AnswerKey"

	# The url for ok
	UrlOk = "URL_OK"

	# The url for error
	UrlError = "URL_ERROR"

	# The encoding method
	EncodingMethod = "EncodingMethod"

	# The payment End Point
	PaymentEndPoint = "PaymentEndPoint"

	# The operation Id
	OperationId = "OPERATIONID"

	# The Currency Code
	CurrencyCode = "CURRENCYCODE"

	# The amount value
	Amount = "AMOUNT"

	# The email client
	EmailCliente = "EMAILCLIENTE"

	# The CSBT City
	CsbtCity = "CSBTCITY"

	# The CSBT Country
	CsbtCountry = "CSBTCOUNTRY"

	# The CSBT Email
	CsbtEmail = "CSBTEMAIL"

	# The CSBT First Name
	CsbtFirstName = "CSBTFIRSTNAME"

	# The CSBT Last Name
	CsbtLastName = "CSBTLASTNAME"

	# The CSBT Phone Number
	CsbtPhoneNumber = "CSBTPHONENUMBER"

	# The CSBT Postal Code
	CsbtPostalCode = "CSBTPOSTALCODE"

	# The CSBT State
	CsbtState = "CSBTSTATE"

	# The CSBT Street 1
	CsbtStreet1 = "CSBTSTREET1"

	# The CSBT Street 2
	CsbtStreet2 = "CSBTSTREET2"

	# The CSBT Customer Id
	CsbtCustomerId = "CSBTCUSTOMERID"

	# The CSBT IP Address
	CsbtIpAddress = "CSBTIPADDRESS"

	# The CSPT currency
	CsptCurrency = "CSPTCURRENCY"

	# The CSPT Grand Total Amount
	CsptGrandTotalAmount = "CSPTGRANDTOTALAMOUNT"

	# The CSMDD 6
	Csmdd6 = "CSMDD6"

	# The CSMDD 7
	Csmdd7 = "CSMDD7"

	# The CSMDD 8
	Csmdd8 = "CSMDD8"

	# The CSMDD 9
	Csmdd9 = "CSMDD9"

	# The CSMDD 10
	Csmdd10 = "CSMDD10"

	# The CSMDD 11
	Csmdd11 = "CSMDD11"

	# The CSST City
	CsstCity = "CSSTCITY"

	# The CSST Country
	CsstCountry = "CSSTCOUNTRY"

	# The CSST Email
	CsstEmail = "CSSTEMAIL"

	# The CSST First Name
	CsstFirstName = "CSSTFIRSTNAME"

	# The CSST Last Name
	CsstLastName = "CSSTLASTNAME"

	# The CSST Phone Number
	CsstPhoneNumber = "CSSTPHONENUMBER"

	# The CSST Postal Code
	CsstPostalCode = "CSSTPOSTALCODE"

	# The CSST State
	CsstState = "CSSTSTATE"

	# The CSST Street 1
	CsstStreet1 = "CSSTSTREET1"

	# The CSST Street 2
	CsstStreet2 = "CSSTSTREET2"

	# The CSIT Product Code
	CsitProductCode = "CSITPRODUCTCODE"

	# The CSIT Product Description
	CsitProductDescription = "CSITPRODUCTDESCRIPTION"

	# The CSIT Product Name
	CsitProductName = "CSITPRODUCTNAME"

	# The CSIT Product SKU
	CsitProductSku = "CSITPRODUCTSKU"

	# The CSIT Total Amount
	CsitTotalAmount = "CSITTOTALAMOUNT"

	# The CSIT Quantity
	CsitQuantity = "CSITQUANTITY"

	# The CSIT Unit Price
	CsitUnitPrice = "CSITUNITPRICE"

	# The CSMD 12
	Csmdd12 = "CSMDD12"

	# The CSMD 13
	Csmdd13 = "CSMDD13"

	# The CSMD 14
	Csmdd14 = "CSMDD14"

	# The CSMD 15
	Csmdd15 = "CSMDD15"

	# The CSMD 16
	Csmdd16 = "CSMDD16"

	def initConnector(self, parameters):
		j_header_http = {self.Authorization:parameters[self.Authorization]}
		return TodoPagoConnector(j_header_http, 'test')

	def executeGetStatus(self, parameters, connector):
		return parameters

	def executeGetAuthorizeAnswer(self, parameters, connector):
		request = self.fillDictionary (parameters,
			[
            self.Security,
            self.Merchant,
            self.RequestKey,
            self.AnswerKey
			])

		return connector.getAuthorizeAnswer(request)
	
	def executeSendAuthorizeRequest(self, parameters, connector):
		request = self.fillDictionary(parameters, 
            [self.Security, 
             self.Session, 
             self.Merchant, 
             self.UrlOk, 
             self.UrlError, 
             self.EncodingMethod,
             self.EmailCliente])

		payload = self.fillDictionary( parameters,[
            self.Merchant.upper(),
            self.OperationId,
            self.CurrencyCode,
            self.Amount,
            self.EmailCliente,
            self.CsbtCity,
            self.CsbtCountry,
            self.CsbtEmail,
            self.CsbtFirstName,
            self.CsbtLastName,
            self.CsbtPhoneNumber,
            self.CsbtPostalCode,
            self.CsbtState,
            self.CsbtStreet1,
            self.CsbtStreet2,
            self.CsbtCustomerId,
            self.CsbtIpAddress,
            self.CsptCurrency,
            self.CsptGrandTotalAmount,
            self.Csmdd6,
            self.Csmdd7,
            self.Csmdd8,
            self.Csmdd9,
            self.Csmdd10,
            self.Csmdd11,
            self.CsstCity,
            self.CsstCountry,
            self.CsstEmail,
            self.CsstFirstName,
            self.CsstLastName,
            self.CsstPhoneNumber,
            self.CsstPostalCode,
            self.CsstState,
            self.CsstStreet1,
            self.CsstStreet2,
            self.CsitProductCode,
            self.CsitProductDescription,
            self.CsitProductName,
            self.CsitProductSku,
            self.CsitTotalAmount,
            self.CsitQuantity,
            self.CsitUnitPrice,
            self.Csmdd12,
            self.Csmdd13,
            self.Csmdd14,
            self.Csmdd15,
            self.Csmdd16])	

		response = connector.sendAuthorizeRequest(request, payload) 

		if not self.RequestKey in response:
			raise NoResponseKeyException("SendAuthorizeRequest response didn't provide a value for %s" % self.RequestKey)

		parameters[self.RequestKey] = str(response[self.RequestKey])

		if not self.PublicRequestKey in response:
			raise NoResponseKeyException("SendAuthorizeRequest response didn't provide a value for %s" % self.PublicRequestKey)

		parameters[self.PublicRequestKey] = str(response[self.PublicRequestKey])

		return asdict(response)

	def executePaymentService(self, parameters, xmlPath):
		xmlPayload = self.loadPaymentMessage(parameters, xmlPath)

		headers = {'Content-Type': 'application/xml'} 		
		result = requests.post(parameters[self.PaymentEndPoint], data=xmlPayload, headers=headers).text 

		parameters[self.AnswerKey] = self.retrieveAnswerKey(result, parameters[self.UrlOk])
		return { "XmlMessage", result };


	def fillDictionary(self, parameters, fields):
		res = {}

		for field in fields:
			try:
				res[field] = parameters[field]
			except Exception, exc:
				raise FieldNotFoundException("Field %s wasn't provided in data file " % field)

		return res		

	def loadPaymentMessage(self, parameters, xmlFile):
		file = open(xmlFile, 'r')
		xmlPayload = file.read()

		xmlPayload = xmlPayload.replace("\n", "")
		xmlPayload = xmlPayload.replace("${" + self.Amount + "}", parameters[self.Amount])
		xmlPayload = xmlPayload.replace("${" + self.RequestKey + "}", parameters[self.PublicRequestKey].replace("t", ""))
		
		return xmlPayload 

	def retrieveAnswerKey(self, xmlResult, urlOk):
		answerKey = ""
		pos = xmlResult.find(urlOk)
		if pos > -1:
			pos = pos  + len(urlOk) + len("?Answer=")
			answerKey = str(xmlResult[pos:pos+36])
		else:
			context["xmlResult"] =  xmlResult
			raise NoResponseKeyException("No answer key as parameter of success url: %s" % urlOk, context)
		
		return 	answerKey

#main entry point
program = Program()
try:	
	if program.evaluateParameters(sys.argv) == 1:
		program.writeResponse(program.executeCommand(program.loadParameters()))
		
except ConfigurationException, exc:
	logError(exc.message)
except NoAnswerKeyException, exc:
	logError(exc.message)
	program.writeResponse(exc.context)
except FieldNotFoundException, exc:
	logError(exc.message)
except Exception, exc:
	traceback.print_exc()