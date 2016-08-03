#!/bin/env ruby
# encoding: utf-8

require '../lib/todo_pago_conector.rb'
require "../lib/user.rb"
require "../lib/Exceptions/empty_field_user_exception.rb"
require "../lib/Exceptions/empty_field_password_exception.rb"
require "../lib/Exceptions/connection_exception.rb"
require "../lib/Exceptions/response_exception.rb"
require '../lib/discover.rb'

require 'uri'
require 'net/protocol'
require 'net/https'
require 'net/http'

class Log

  ##########################
  # Log title
  # @param [String] message
  ##########################
  def title(message)
    puts message.upcase
  end

  ##########################
  # Log message info
  # @param [String] message
  ##########################
  def info(message)
    puts 'INFO: ' + message
  end

  ##########################
  # Writes a error message with red color
  # @param [String] message
  ##########################
  def error(message)
    puts 'ERROR: ' + message
  end
end

class ConfigurationException < StandardError

  def initialize(message)
    super(message)
  end
end

class FieldNotFoundException < Exception
  def initialize(message)
    super(message)
  end
end

class NoResponseKeyException < Exception
  @context = nil
  def initialize(message, context)
    super(message)
    @context = context
  end
end

class Program
    # Available operations
    SEND_REQUEST = 'SendAuthorizeRequest'
    GET_ANSWER = 'GetAuthorizeAnswer'
    PAYMENT_FLOW = 'PaymentFlow'
    BSA_DISCOVER = 'BSADiscover'

    @input_path = nil
    @output_path = nil
    @xml_path = nil
    @command = nil
    @log = nil

    def get_input_path
        @input_path
    end

    def set_input_path(value)
        @input_path = value
    end

    def get_output_path
        @output_path
    end

    def set_output_path(value)
        @output_path = value
    end

    def get_xml_path
        @xml_path
    end

    def set_xml_path(value)
        @xml_path = value
    end

    def get_command
        @command
    end

    def set_command(value)
        @command = value
    end

    ##########################
    # Gets a new instance of Program
    ##########################
    def initialize
        @available_commands = Array.new
        @available_commands = [SEND_REQUEST, GET_ANSWER, PAYMENT_FLOW]

        @log = Log.new
    end

    ##########################
    # Loads the parameters from input file
    # @return [Hash] a hash of parameters
    ##########################
    def load_parameters
        parameters = Hash.new

        File.open(@input_path, 'r') do |f1|
            while lines = f1.gets

                lines = lines.chomp

                unless (lines.empty?) or lines[0,5].include?('//')
                    line = lines.split('=')

                    parameter = line[0].to_s.strip
                    value = line[1].to_s.strip

                    parameter = 'security' if parameter =='Security'
                    parameter = 'URL_OK' if parameter == 'URL OK'
                    parameter = 'URL_ERROR' if parameter == 'URL Error'
                    parameter = 'EncodingMethod' if parameter == 'Encoding Method'

                    value = '' if value == 'null'
                    name = parameter.to_s

                    parameters[name.to_sym] = value
                end
            end
        end

        parameters
    end

    ##########################
    # Evaluates and fills the program's parameters
    # For SendAuthorizeRequest: c:SendAuthorizeRequest /i:.\Samples\Sample_01_SendRequest.ini /o:.\Samples\Sample_01_SendRequest.out
    # For Payment flow: /c:PaymentFlow /i:.\Samples\Sample_01_PaymentFlow.ini /o:.\Samples\Sample_01_PaymentFlow.out /x:.\Samples\WS_Execute_Request.xml
    ##########################
    def evaluate_parameters(args)
        args.each do |cmd|
            param = cmd.downcase

            if param.start_with?('/?')
                puts 'Usage mode: > ruby Adapter.rb /c:{command} /i:{Path and file} /o:{Path and file} /x:{Path and File}'
                puts 'Where:'
                puts '/c: The command name, must be one of following:' + @available_commands.join(",")
                puts '/i: Path and filename for input file (command''s parameters values file)'
                puts '/o: Path and filename for output file (command''s response file)'
                puts '/x: Path and filename for xml payment service, requires for ' + PAYMENT_FLOW + ' command'
                return false

            elsif param.start_with?('/c:')
                self.set_command(cmd[3,cmd.length])
                raise ConfigurationException.new("Command [#{@command}] is unrecognized.") unless @available_commands.include?(@command)

            elsif param.start_with?('/i:')
                self.set_input_path(File.expand_path(cmd[3,cmd.length] ,__FILE__))
                raise ConfigurationException.new("File [#{@input_path}] not found.") unless File.exist?(@input_path)

            elsif param.start_with?('/o:')
                self.set_output_path(File.expand_path(cmd[3,cmd.length] ,__FILE__))
                raise ConfigurationException.new("Path [#{File.dirname(@output_path)}] not found.") unless File.directory?(File.dirname(@output_path))

            elsif param.start_with?('/x:')
                self.set_xml_path(File.expand_path(cmd[3,cmd.length] ,__FILE__))
                raise ConfigurationException.new("File [#{@xml_path}] not found.") unless File.exist?(@xml_path)
            end
        end

        raise ConfigurationException.new('Command was not been configured, execute with /? for more information') if @command.nil?
        raise ConfigurationException.new('InputPath was not been configured, execute with /? for more information') if @input_path.nil?
        raise ConfigurationException.new('OutputPath was not  been configured, execute with /? for more information') if @output_path.nil?
        raise ConfigurationException.new('XmlPath was not  been configured, execute with /? for more information') if @xml_path.nil? and @command.equal?(PAYMENT_FLOW)

        @log.info('Configuration completed.')
        true
    end

    ##########################
    # Executes the command
    # @param [Hash] parameters
    # @return [Hash]
    ##########################
    def execute_command(parameters)

        response = Hash.new
        adapter = SdkServices.new

        connector = adapter.init_connector(parameters)

        case @command
            when SEND_REQUEST
                response = adapter.execute_send_authorize_request(parameters, connector)

            when GET_ANSWER
                response = adapter.execute_get_authorize_answer(parameters, connector)

            when PAYMENT_FLOW
                res = Hash.new
                res[SEND_REQUEST] = adapter.execute_send_authorize_request(parameters, connector)
                res[PAYMENT_FLOW] = adapter.execute_payment_service(parameters, @xml_path)
                res[GET_ANSWER] = adapter.execute_get_authorize_answer(parameters, connector)
                response = res

          when BSA_DISCOVER
                response =  adapter
            else
                @log.error("No command executed for #{@command}")
        end

        @log.info("Command #{@command} has been executed.")

        response
    end

    ##########################
    # Writes the response to output file
    # @param [String] message
    ##########################
    def write_response(message)

        f = File.open(@output_path, 'w')
        self.write_dictionary(message, f)
        f.close

        @log.info("File #{@output_path} has been written.")
    end

    ##########################
    # Writes a dictionary into String Builder
    # @param [String] message
    # @param [String] f
    ##########################
    def write_dictionary(message, f)

        message.each do |key, value|

            if value.instance_of?(Hash)
                f.write("****************** #{key.to_s} ****************************\n")
                self.write_dictionary(value, f)
                f.write("\n")
            else
                f.write("#{key.to_s}=#{value.to_s}\n")
            end
        end
    end
end

class SdkServices

  ##########################
  # Constants
  ##########################
  END_POINT = 'EndPoint'.to_sym
  PAYMENT_END_POINT = 'PaymentEndPoint'.to_sym
  AUTHORIZATION = 'Authorization'.to_s
  MERCHANT = 'MERCHANT'.to_sym
  OPERATIONID = 'OPERATIONID'.to_sym
  CURRENCYCODE = 'CURRENCYCODE'.to_sym
  AMOUNT = 'AMOUNT'.to_sym
  CSBTCITY = 'CSBTCITY'.to_sym
  CSSTCITY = 'CSSTCITY'.to_sym
  CSBTCOUNTRY = 'CSBTCOUNTRY'.to_sym
  CSSTCOUNTRY = 'CSSTCOUNTRY'.to_sym
  CSBTEMAIL = 'CSBTEMAIL'.to_sym
  CSSTEMAIL = 'CSSTEMAIL'.to_sym
  CSBTFIRSTNAME = 'CSBTFIRSTNAME'.to_sym
  CSSTFIRSTNAME = 'CSSTFIRSTNAME'.to_sym
  CSBTLASTNAME = 'CSBTLASTNAME'.to_sym
  CSSTLASTNAME = 'CSSTLASTNAME'.to_sym
  CSBTPHONENUMBER = 'CSBTPHONENUMBER'.to_sym
  CSSTPHONENUMBER = 'CSSTPHONENUMBER'.to_sym
  CSBTPOSTALCODE = 'CSBTPOSTALCODE'.to_sym
  CSSTPOSTALCODE = 'CSSTPOSTALCODE'.to_sym
  CSBTSTATE = 'CSBTSTATE'.to_sym
  CSSTSTATE = 'CSSTSTATE'.to_sym
  CSBTSTREET1 = 'CSBTSTREET1'.to_sym
  CSSTSTREET1 = 'CSSTSTREET1'.to_sym
  CSBTCUSTOMERID = 'CSBTCUSTOMERID'.to_sym
  CSBTIPADDRESS = 'CSBTIPADDRESS'.to_sym
  CSPTCURRENCY = 'CSPTCURRENCY'.to_sym
  CSPTGRANDTOTALAMOUNT = 'CSPTGRANDTOTALAMOUNT'.to_sym
  CSMDD7 = 'CSMDD7'.to_sym
  CSMDD8 = 'CSMDD8'.to_sym
  CSMDD9 = 'CSMDD9'.to_sym
  CSMDD10 = 'CSMDD10'.to_sym
  CSMDD11 = 'CSMDD11'.to_sym
  CSMDD12 = 'CSMDD12'.to_sym
  CSMDD13 = 'CSMDD13'.to_sym
  CSMDD14 = 'CSMDD14'.to_sym
  CSMDD15 = 'CSMDD15'.to_sym
  CSMDD16 = 'CSMDD16'.to_sym
  CSITPRODUCTCODE = 'CSITPRODUCTCODE'.to_sym
  CSITPRODUCTDESCRIPTION = 'CSITPRODUCTDESCRIPTION'.to_sym
  CSITPRODUCTNAME = 'CSITPRODUCTNAME'.to_sym
  CSITPRODUCTSKU = 'CSITPRODUCTSKU'.to_sym
  CSITTOTALAMOUNT = 'CSITTOTALAMOUNT'.to_sym
  CSITQUANTITY = 'CSITQUANTITY'.to_sym
  CSITUNITPRICE = 'CSITUNITPRICE'.to_sym
  SECURITY = 'security'.to_sym
  ENCODING_METHOD = 'EncodingMethod'.to_sym
  URL_OK = 'URL_OK'.to_sym
  URL_ERROR = 'URL_ERROR'.to_sym
  EMAIL_CLIENTE = 'EMAILCLIENTE'.to_sym
  SESSION = 'Session'.to_sym
  REQUEST_KEY = 'request_key'.to_sym
  ANSWER_KEY = 'AnswerKey'.to_sym
  STARD_DATE = 'STARTDATE'.to_sym
  END_DATE = 'ENDDATE'.to_sym
  PAGE_NUMBER = 'PAGENUMBER'.to_sym
  PUBLIC_REQUEST_KEY = 'public_request_key'.to_sym

  def initialize
  end
  ##########################
  # Init Connector
  # @param [String] parameters
  # @return [TodoPagoConector]
  ##########################
  def init_connector(parameters)
      header = Hash.new
      header[AUTHORIZATION] = parameters[:Authorization]

      TodoPagoConector.new(header, "test")
  end


  ##########################
  # Execute the sendAuthorizeRequest method
  # @param [Hash] parameters
  # @param [TodoPagoConector] connector
  # @return [Hash]
  ##########################
  def execute_send_authorize_request(parameters, connector)
      payload = self.fill_dictionary(parameters, [
          MERCHANT,
          OPERATIONID,
          CURRENCYCODE,
          AMOUNT,
          CSBTCITY,
          CSSTCITY,
          CSBTCOUNTRY,
          CSSTCOUNTRY,
          CSBTEMAIL,
          CSSTEMAIL,
          CSBTFIRSTNAME,
          CSSTFIRSTNAME,
          CSBTLASTNAME,
          CSSTLASTNAME,
          CSBTPHONENUMBER,
          CSSTPHONENUMBER,
          CSBTPOSTALCODE,
          CSSTPOSTALCODE,
          CSBTSTATE,
          CSSTSTATE,
          CSBTSTREET1,
          CSSTSTREET1,
          CSBTCUSTOMERID,
          CSBTIPADDRESS,
          CSPTCURRENCY,
          CSPTGRANDTOTALAMOUNT,
          CSMDD7,
          CSMDD8,
          CSMDD9,
          CSMDD10,
          CSMDD11,
          CSMDD12,
          CSMDD13,
          CSMDD14,
          CSMDD15,
          CSMDD16,
          CSITPRODUCTCODE,
          CSITPRODUCTDESCRIPTION,
          CSITPRODUCTNAME,
          CSITPRODUCTSKU,
          CSITTOTALAMOUNT,
          CSITQUANTITY,
          CSITUNITPRICE])

      #default values
      payload[:AVAILABLEPAYMENTMETHODSIDS]= '1#194#43#45'
      payload[:PUSHNOTIFYMETHOD]= ''
      payload[:PUSHNOTIFYENDPOINT]= ''
      payload[:PUSHNOTIFYSTATES]= ''

      request = self.fill_dictionary(parameters, [SECURITY,
                                                  MERCHANT,
                                                  ENCODING_METHOD,
                                                  URL_OK,
                                                  URL_ERROR,
                                                  EMAIL_CLIENTE,
                                                  SESSION])

      response = connector.sendAuthorizeRequest(request, payload)

      parameters = self.fill_post_send_authorize_request(parameters, response)

      return response
  end

  ##########################
  # Fill fields RequestKey and PublicRequestKey into parameters
  # @param [Hash] parameters
  # @param [Hash] response
  # @return [Hash]
  ##########################
  def fill_post_send_authorize_request(parameters, response)
      response.each do |key, value|
          unless value.instance_of?(Hash)
              if key == "request_key".to_sym
                  parameters[REQUEST_KEY] = value
              end

              if key == "public_request_key".to_sym
                  parameters[PUBLIC_REQUEST_KEY] = value
              end
          else
              self.fill_post_send_authorize_request(parameters, value)
          end
      end

      raise NoResponseKeyException.new("SendAuthorizeRequest response didn't provide a value for #{REQUEST_KEY}", response) if !parameters.key?(REQUEST_KEY)
      raise NoResponseKeyException.new("SendAuthorizeRequest response didn't provide a value for #{PUBLIC_REQUEST_KEY}", response) if !parameters.key?(REQUEST_KEY)
      
      parameters
  end

  ##########################
  # Executes the GetAuthorizeAnswer methodf
  # @param [Hash] parameters
  # @param [TodoPagoConector] connector
  # @return [Hash]
  ##########################
  def execute_get_authorize_answer(parameters, connector)
      request = self.fill_dictionary(parameters, [SECURITY, MERCHANT, ANSWER_KEY])
      request[:RequestKey] = parameters[REQUEST_KEY]

      connector.getAuthorizeAnswer(request)
  end


  ##########################
  # Execute the getOperations method
  # @param [Hash] parameters
  # @param [TodoPagoConector] connector
  # @return [Hash]
  ##########################
  def execute_get_operations(parameters, connector)
      request = self.fill_dictionary(parameters, [MERCHANT, OPERATIONID])

      connector.getOperations(request)
  end

  ##########################
  # Executes the payment web services
  # @param [Hash] parameters
  # @param [String] xml_file
  # @return [Hash]
  ##########################
  def execute_payment_service(parameters, xml_file)

      xml_payload = self.load_payment_message(parameters, xml_file)

      uri = URI(parameters[PAYMENT_END_POINT])
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE

      init_header = Hash.new
      init_header['Content-Type'] = 'application/soap+xml'
      init_header['Content-Length'] = xml_payload.length.to_s
      init_header['SOAPAction'] = parameters[PAYMENT_END_POINT]

      output = https.post(uri.path ,xml_payload, init_header)
      xml_response = output.body

      parameters[ANSWER_KEY] = self.retrieve_answer_key(xml_response, parameters[URL_OK])

      response = Hash.new
      response['xmlMessage'] = xml_response
      return response
  end


  ##########################
  # Execute the BSA Disconvery method
  # @param [TodoPagoConector] connector
  # @return [Hash]
  ##########################
  def execute_bsa_discovery(connector)
      discover = Discover.new()
      discover = conector.discoverPaymentMethods(discover)
      return discover
  end
  ##########################
  # Recovery the values from required list into dictionary
  # @param [Hash] parameters
  # @param [Hash] fields
  # @return [Hash]
  ##########################
  def fill_dictionary(parameters, fields)
      res = Hash.new
      fields.each { |field|
          if parameters.key?(field)
              res[field] = parameters[field]
          else
              raise FieldNotFoundException.new("Field #{field} wasn't provided in data file.")
          end
      }
      res
  end

  def write_message(message)
    message.each do |key, value|
        puts "#{key.to_s}=#{value.to_s}\n"
    end
  end
  ##########################
  # Retrieve the value of AnswerKey from xml message
  # @param [String] xml_result
  # @param [String] url_ok
  # @return [String]
  ##########################
  def retrieve_answer_key(xml_result, url_ok)

    pos = xml_result.index(url_ok)

    if pos > 0
      pos = pos + (url_ok + '?Answer=').length
      result = xml_result[pos, 36]
    else
      raise NoResponseKeyException.new("No answer key as parameter of success url: #{url_ok}", xml_result)
    end

    result
  end


  ##########################
  # Loads and compose web services payment message
  # @param [Hash] parameters
  # @param [String] xml_file
  # @return [String]
  ##########################
  def load_payment_message(parameters, xml_file)
      xml_payload = File.read(xml_file)
      xml_payload = xml_payload.gsub("\${#{AMOUNT}}", parameters[AMOUNT])
      xml_payload.gsub("${PublicRequestKey}", parameters[PUBLIC_REQUEST_KEY].gsub('t',''))
  end

end

def main(args)
  program = Program.new
  log = Log.new

  program.write_response(program.execute_command(program.load_parameters)) if program.evaluate_parameters(args)

rescue ConfigurationException => e
  log.error("#{e}")

rescue NoResponseKeyException => e
  log.error("#{e}")
  program.write_response(e.context)

rescue FieldNotFoundException => e
  log.error("#{e}")

rescue Exception => e
  log.error("#{e}")
  log.error(e.backtrace.join("\n"))
end

main(ARGV)