<?php

include_once '../lib/vendor/autoload.php';
include_once '../lib/Sdk.php';

use TodoPago\Sdk;

// php Adapter.php /c:SendAuthorizeRequest /i:Samples\Sample_01_SendRequest.ini /o:Samples\Salida.out
// php Adapter.php /c:GetAuthorizeAnswer /i:Samples\Sample_01_Answer.ini /o:Samples\Salida.out
// php Adapter.php /c:PaymentFlow /i:Samples\Sample_01_PaymentFlow.ini /o:Samples\Salida.out /x:Samples\WS_Execute_Request.xml

class NoResponseKeyException extends ErrorException {

    public $context;
    
    public function __construct($message, $context) {
        parent::__construct($message);
        $this->context = $context;
    }
}

class FieldNotFoundException extends ErrorException {
    
    public function __construct($message) {
        parent::__construct($message);
    }
}

class ConfigurationException extends ErrorException {
    
    public function __construct($message) {
        parent::__construct($message);
    }
}

class Log {  
    /**
    * Return an item from the argument list
    * @param String $message
    */
    public static  function Error($message) 
    {    
        echo 'ERROR: '.$message.PHP_EOL;
    }
    
    public static function Info($message) 
    {  
        echo 'INFO: '.$message.PHP_EOL;
    }
    
    public static function Title($message) 
    {  
        echo $message.PHP_EOL;
    }
}

class Program{
    
    const SendRequest = "SendAuthorizeRequest";
    const GetAnswer = "GetAuthorizeAnswer";
    const PaymentFlow = "PaymentFlow";

    private static $AvailableCommands;

    private $InputPath;
    private $OutputPath;
    private $Command;
    private $XmlPath;

    /* 
     * @var $this Program 
     * 
     */
    public function __construct()
    {                       
        self::$AvailableCommands = array (self::SendRequest, self::GetAnswer, self::PaymentFlow);
    }
        
    public function EvaluateParameters($args)
    {
        foreach ($args as $key => $value) 
        {
            if (strncmp(strtolower($value), "/?", 2) == 0)
            {
                echo "Usage mode: > php Adapter.php /c:{command} /i:{Path and file} /o:{Path and file} /x:{Path and File}".PHP_EOL;
                echo "Where: ".PHP_EOL;
                echo "/c: The command name, must be one of following: ".join(',',self::$AvailableCommands).PHP_EOL;
                echo "/i: Path and filename for input file (command's parameters values file)".PHP_EOL;
                echo "/o: Path and filename for output file (command's response file)".PHP_EOL;
                echo "/x: Path and filename for xml payment service, requires for ".self::PaymentFlow." command".PHP_EOL;
                return false;
            }

            if (strncmp(strtolower($value), "/c:", 3) == 0)
            {
                $this->Command = substr($value, 3, strlen($value)-3);

                if (!in_array($this->Command, self::$AvailableCommands)) 
                {
                    throw new ConfigurationException("Command [".$this->Command."] is unrecognized.");    
                }
            }
            else if (strncmp(strtolower($value), "/i:", 3) == 0)
            {
                $this->InputPath = substr($value, 3, strlen($value)-3);     

                if (!file_exists($this->InputPath)) 
                {
                    throw new ConfigurationException("File [".$this->InputPath."] not found.");
                }  
            }
            else if (strncmp(strtolower($value), "/o:", 3) == 0)
            {
                $this->OutputPath = substr($value, 3, strlen($value)-3);                    

                if (!file_exists(dirname($this->OutputPath)))
                {
                    throw new ConfigurationException("Path [".dirname($this->OutputPath)."] not found.");
                }
            }
            else if (strncmp(strtolower($value), "/x:", 3) == 0)
            {
                $this->XmlPath = substr($value, 3, strlen($value)-3);

                if (!file_exists($this->XmlPath)) 
                {
                    throw new ConfigurationException("File [".$this->XmlPath."] not found.");
                } 
            }            
        }
        
        if (is_null($this->Command) or empty($this->Command))
        {
            throw new ConfigurationException("Command wasn't been configured, execute with /? for more information");
        }

        if (is_null($this->InputPath) or empty($this->InputPath))
        {
            throw new ConfigurationException("InputPath wasn't been configured, execute with /? for more information");
        }

        if (is_null($this->OutputPath) or empty($this->OutputPath))
        {
            throw new ConfigurationException("OutputPath wasn't been configured, execute with /? for more information");
        }

        if ((is_null($this->XmlPath) or empty($this->XmlPath)) and ($this->Command == self::PaymentFlow))
        {
            throw new ConfigurationException("XmlPath wasn't been configured, execute with /? for more information");
        }

        Log::Info("Configuration completed.");
        return true;
    }

    
    // <summary>
    // Loads the parameters from input file
    // </summary>
    // <returns>The parameters loaded</returns>
    public function LoadParameters()
    {
        $parameters = array();
        
        $file = file($this->InputPath, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

        foreach ($file as $key => $line) 
        {
            
            if (is_null($line) or empty($line) or strpos(substr($line, 0, 5), '//')!== false )
            {
                continue;
            }
            
            list($keyValue, $value) = explode("=", $line);

            if ((is_null($value)) or empty($value))
            {
                throw new ConfigurationException("No value defined in [".$line."] line of ini file.");
            }
            
            $value = trim($value);            
            if (strtolower($value) == "null")
            {
                $value = "";
            }
            else
            {
                $value = trim($value);
            }
            
            $keyValue = trim($keyValue);
            if ($keyValue == "URL OK")
            {
                $keyValue = "URL_OK";
            } 
            else if ($keyValue == "URL Error")
            {
                $keyValue = "URL_ERROR";
            } 
            else if ($keyValue == "Encoding Method")
            {
                $keyValue = "EncodingMethod";
            }          
            
            $parameters[$keyValue] = $value;            
        }
        
        Log::Info("File [".$this->InputPath."] has been loaded.");
        
        return $parameters;
    }
           
    
    // <summary>Executes the command</summary>
    // <param name="parameters">The dictionary of parameters</param>
    // <returns>The response command.</returns>
    public function ExecuteCommand($parameters)
    {
        $response = NULL;
        $SdkServices = new SdkServices();

        $connector = $SdkServices->InitConnector($parameters);

        switch ($this->Command)
        {
            case self::SendRequest:
                $response[self::SendRequest] = $SdkServices->ExecuteSendAuthorizeRequest($parameters, $connector);
                break;
            
            case self::GetAnswer:
                $response[self::GetAnswer] = $SdkServices->ExecuteGetAuthorizeAnswer($parameters, $connector);
                break;
            
            case self::PaymentFlow:
                $res = Array();
                $res[self::SendRequest] = $SdkServices->ExecuteSendAuthorizeRequest($parameters, $connector);          
                $res[self::PaymentFlow] = $SdkServices->ExecutePaymentService($parameters, $this->XmlPath);
                $res[self::GetAnswer] = $SdkServices->ExecuteGetAuthorizeAnswer($parameters, $connector);              
                $response = $res;
                break;
        }

        Log::Info("Command [".$this->Command."] has been executed.");
        return $response;
    }
    
    
    /// <summary>
    /// Writes the response to output file 
    /// </summary>
    /// <param name="message">The response message</param>
    public function WriteResponse($message)
    {
        $file = fopen($this->OutputPath, "w");
        self::WriteDictionary($message, $file);
        fclose($file);
        
        Log::Info("File ".$this->OutputPath." has been written.");
    }

    /// <summary>
    /// Writes a dictionary into String Builder
    /// </summary>
    /// <param name="message">The dictionary to write</param>
    /// <param name="buffer">The buffer to contain the message</param>
    private static function WriteDictionary($message, $file)
    {
        foreach ($message as $key => $value) 
        {
            if (is_array($value)) 
            {
                if (empty($value))
                {
                    continue;
                }
                fwrite($file, "****************** ".$key." ****************************". PHP_EOL);
                self::WriteDictionary($value, $file);
                fwrite($file, PHP_EOL);
            }
            else
            {
                fwrite($file, $key."=".$value. PHP_EOL);                
            }
        }       
    }
}

class SdkServices {
    
    const EndPoint = "EndPoint";
    const Authorization = "Authorization";
    const Security = "Security";
    const Session = "Session";
    const Merchant = "Merchant";
    const RequestKey = "RequestKey";
    const PublicRequestKey = "PublicRequestKey";
    const AnswerKey = "AnswerKey";
    const UrlOk = "URL_OK";
    const UrlError = "URL_ERROR";
    const EncodingMethod = "EncodingMethod";
    const PaymentEndPoint = "PaymentEndPoint";
    const OperationId = "OPERATIONID";
    const CurrencyCode = "CURRENCYCODE";
    const Amount = "AMOUNT";
    const EmailCliente = "EMAILCLIENTE";
    const CsbtCity = "CSBTCITY";
    const CsbtCountry = "CSBTCOUNTRY";
    const CsbtEmail = "CSBTEMAIL";
    const CsbtFirstName = "CSBTFIRSTNAME";

    /// The CSBT Last Name
    const CsbtLastName = "CSBTLASTNAME";

    /// The CSBT Phone Number
    const CsbtPhoneNumber = "CSBTPHONENUMBER";

    /// The CSBT Postal Code
    const CsbtPostalCode = "CSBTPOSTALCODE";

    /// The CSBT State
    const CsbtState = "CSBTSTATE";

    /// The CSBT Street 1
    const CsbtStreet1 = "CSBTSTREET1";

    /// The CSBT Street 2
    const CsbtStreet2 = "CSBTSTREET2";

    /// The CSBT Customer Id
    const CsbtCustomerId = "CSBTCUSTOMERID";

    /// The CSBT IP Address
    const CsbtIpAddress = "CSBTIPADDRESS";

    /// The CSPT currency
    const CsptCurrency = "CSPTCURRENCY";

    /// The CSPT Grand Total Amount
    const CsptGrandTotalAmount = "CSPTGRANDTOTALAMOUNT";

    /// The CSMDD 6
    const  Csmdd6 = "CSMDD6";

    /// The CSMDD 7
    const Csmdd7 = "CSMDD7";

    /// The CSMDD 8
    const Csmdd8 = "CSMDD8";

    /// The CSMDD 9
    const Csmdd9 = "CSMDD9";

    /// The CSMDD 10
    const Csmdd10 = "CSMDD10";

    /// The CSMDD 11
    const Csmdd11 = "CSMDD11";

    /// The CSST City
    const CsstCity = "CSSTCITY";

    /// The CSST Country
    const CsstCountry = "CSSTCOUNTRY";

    /// The CSST Email
    const CsstEmail = "CSSTEMAIL";

    /// The CSST First Name
    const CsstFirstName = "CSSTFIRSTNAME";

    /// The CSST Last Name
    const CsstLastName = "CSSTLASTNAME";

    /// The CSST Phone Number
    const CsstPhoneNumber = "CSSTPHONENUMBER";

    /// The CSST Postal Code
    const CsstPostalCode = "CSSTPOSTALCODE";

    /// The CSST State
    const CsstState = "CSSTSTATE";

    /// The CSST Street 1
    const CsstStreet1 = "CSSTSTREET1";

    /// The CSST Street 2
    const CsstStreet2 = "CSSTSTREET2";

    /// The CSIT Product Code
    const CsitProductCode = "CSITPRODUCTCODE";

    /// The CSIT Product Description
    const CsitProductDescription = "CSITPRODUCTDESCRIPTION";

    /// The CSIT Product Name
    const CsitProductName = "CSITPRODUCTNAME";

    /// The CSIT Product SKU
    const CsitProductSku = "CSITPRODUCTSKU";

    /// The CSIT Total Amount
    const CsitTotalAmount = "CSITTOTALAMOUNT";

    /// The CSIT Quantity
    const CsitQuantity = "CSITQUANTITY";

    /// The CSIT Unit Price
    const CsitUnitPrice = "CSITUNITPRICE";

    /// The CSMD 12
    const Csmdd12 = "CSMDD12";

    /// The CSMD 13
    const Csmdd13 = "CSMDD13";

    /// The CSMD 14
    const Csmdd14 = "CSMDD14";

    /// The CSMD 15
    const Csmdd15 = "CSMDD15";

    /// The CSMD 16
    const Csmdd16 = "CSMDD16";  
    
    /// <summary>
    /// Initializes the TP connector
    /// </summary>
    /// <param name="parameters">The dictionary parameters</param>
    /// <returns>A TP connector initialized</returns>
    public static function InitConnector($parameters)
    {
        $headers = array(
                        self::Authorization => $parameters[self::Authorization]    
                        );

        return new Sdk($headers);
    }
    
    
    /// <summary>
    /// Executes the GetAuthorizeAnswer method
    /// </summary>
    /// <param name="parameters">The method parameters</param>
    /// <param name="connector">The initialized connector</param>
    /// <returns>The service response</returns>
    public static function ExecuteSendAuthorizeRequest(& $parameters, $connector)
    {
        $request = self::FillDictionary(
                                        $parameters, 
                                        Array(
                                                self::Security, 
                                                self::Session, 
                                                self::Merchant, 
                                                self::UrlOk, 
                                                self::UrlError, 
                                                self::EncodingMethod
                                            )
                                        );
                                        
        $payload = self::FillDictionary(
                $parameters,
                Array(
                        strtoupper(self::Merchant),
                        self::OperationId,
                        self::CurrencyCode,
                        self::Amount,
                        self::EmailCliente,
                        self::CsbtCity,
                        self::CsbtCountry,
                        self::CsbtEmail,
                        self::CsbtFirstName,
                        self::CsbtLastName,
                        self::CsbtPhoneNumber,
                        self::CsbtPostalCode,
                        self::CsbtState,
                        self::CsbtStreet1,
                        self::CsbtStreet2,
                        self::CsbtCustomerId,
                        self::CsbtIpAddress,
                        self::CsptCurrency,
                        self::CsptGrandTotalAmount,
                        self::Csmdd6,
                        self::Csmdd7,
                        self::Csmdd8,
                        self::Csmdd9,
                        self::Csmdd10,
                        self::Csmdd11,
                        self::CsstCity,
                        self::CsstCountry,
                        self::CsstEmail,
                        self::CsstFirstName,
                        self::CsstLastName,
                        self::CsstPhoneNumber,
                        self::CsstPostalCode,
                        self::CsstState,
                        self::CsstStreet1,
                        self::CsstStreet2,
                        self::CsitProductCode,
                        self::CsitProductDescription,
                        self::CsitProductName,
                        self::CsitProductSku,
                        self::CsitTotalAmount,
                        self::CsitQuantity,
                        self::CsitUnitPrice,
                        self::Csmdd12,
                        self::Csmdd13,
                        self::Csmdd14,
                        self::Csmdd15,
                        self::Csmdd16
                    )
                );
        
        $response = $connector->sendAuthorizeRequest($request, $payload);

        if (!array_key_exists(self::RequestKey, $response)){
            throw new NoResponseKeyException("SendAuthorizeRequest response didn't provide a value for ".self::RequestKey, $response);
        }

        if (!array_key_exists(self::PublicRequestKey, $response)){
            throw new NoResponseKeyException("SendAuthorizeRequest response didn't provide a value for ".self::PublicRequestKey, $response);
        }

        $parameters[self::RequestKey] = $response[self::RequestKey];
        $parameters[self::PublicRequestKey] = $response[self::PublicRequestKey];

        return $response;                
    }
    
    
    /// <summary>
    /// Recovery the values from required list into dictionary
    /// </summary>
    /// <param name="parameters">The loaded parameters</param>
    /// <param name="fields">The required fields</param>
    /// <returns> A new dictionary </returns>
    private static function FillDictionary($parameters, $fields)
    {
        $res = Array();

        foreach ($fields as $key => $field)
        {
            try
            {
                $res[$field] = $parameters[$field];
            }
            catch (FieldNotFoundException $e)
            {
                throw new FieldNotFoundException("Field ".$field." wasn't been provided in data file ");
            }
        }

        return $res;
    }
    
    
    /// <summary>
    /// Executes the GetAuthorizeAnswer method
    /// </summary>
    /// <param name="parameters">The method parameters</param>
    /// <param name="connector">The initialized connector</param>
    /// <returns>The service response</returns>
    public static function ExecuteGetAuthorizeAnswer($parameters, $connector)
    {
        $request = self::FillDictionary(
                                        $parameters, 
                                        Array(
                                                self::Security, 
                                                self::Session, 
                                                self::Merchant, 
                                                self::RequestKey, 
                                                self::AnswerKey
                                            )
                                        );      
       
        return $connector->GetAuthorizeAnswer($request);
    }

    
    /// <summary>
    /// Execute the GetStatus method
    /// </summary>
    /// <param name="parameters">The method parameters</param>
    /// <param name="connector">The initialized connector</param>
    /// <returns>The service response</returns>
    public static function ExecuteGetStatus($parameters, $connector)
    {
        $request = Array(
                        strtoupper(self::Merchant) => $parameters[self::Merchant], 
                        self::OperationId => $parameters[self::OperationId]
                  );
        
        $res = $connector->getStatus($request);

        return $res['Operations'];
    }
    
    
    
    /// <summary>
    /// Executes the payment web services
    /// </summary>
    /// <param name="parameters">
    /// The dictionary parameters
    /// </param>
    /// <param name="xmlFile">
    /// The xml File.
    /// </param>
    /// <returns>
    /// The service response
    /// </returns>
    public static function ExecutePaymentService(& $parameters, $xmlFile)
    {
        $res = Array();
        $xmlPayload = self::LoadPaymentMessage($parameters, $xmlFile);

        $url = $parameters[self::PaymentEndPoint];
        
        $ch = curl_init($url);

        curl_setopt($ch, CURLOPT_POSTFIELDS, $xmlPayload);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 300);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE); 

        $headers = array(
            "Content-type: application/soap+xml;",
            "Content-length: ".strlen($xmlPayload),
            "SOAPAction: ".$url);

        curl_setopt( $ch, CURLOPT_HTTPHEADER, $headers);


        if (curl_errno($ch)) 
        {
            // moving to display page to display curl errors
            #echo curl_errno($ch) ;
            #echo curl_error($ch);
        } 
        else 
        {
            $response = curl_exec($ch);
            curl_close($ch);
        }

        $parameters[self::AnswerKey] = self::RetrieveAnswerKey($response, $parameters[self::UrlOk]);

        $res["xmlMessage"] = $response;
        return $res;
    }
    
    
    
    /// <summary>
    /// Loads and compose web services payment message
    /// </summary>
    /// <param name="parameters">The parameters dictionary</param>
    /// <param name="xmlFile">The xml data file</param>
    /// <returns>The xml payment message</returns>
    private static function LoadPaymentMessage($parameters, $xmlFile)
    {
        $file = fopen($xmlFile, "r");
        $xmlPayload = fread($file, filesize($xmlFile));  
        $xmlPayload = str_replace("\${".self::Amount."}", $parameters[self::Amount], $xmlPayload);
        $xmlPayload = str_replace("\${".self::PublicRequestKey."}", str_replace('t', '', $parameters[self::PublicRequestKey]), $xmlPayload);

        return $xmlPayload;
    }
    
    
    /// <summary>
    /// Retrieve the value of AnswerKey from xml message
    /// </summary>
    /// <param name="xmlResult">The xml message</param>
    /// <param name="urlOk">The success url</param>
    /// <returns>The value of answer key</returns>
    private static function RetrieveAnswerKey($xmlResult, $urlOk)
    {
        $pos = stripos($xmlResult, $urlOk);
        
        if ($pos > 0)
        {
            $pos += strlen($urlOk."?Answer=");
            $result = substr($xmlResult, $pos, 36);
        } 
        else
        {
            throw new NoResponseKeyException("No answer key as parameter of success url: ".$urlOk, $xmlResult);
        }

        return $result;
    }
    
}

function Main($args)
{
    $program = new Program();
    try 
    {
        if ($program->EvaluateParameters($args)) 
        {
            $program->WriteResponse(
                                $program->ExecuteCommand(
                                                    $program->LoadParameters()
                                )
            );
        }  
    } 
    catch (ConfigurationException $e) 
    {
        Log::Error($e->getMessage());
    }        
    catch (NoResponseKeyException $e) 
    {
        Log::Error($e->getMessage());
        Log::Error($e->context);
    }
    catch (FieldNotFoundException $e) 
    {
        Log::Error($e->getMessage());
    }
    catch (Exception $e) 
    {
        Log::Error($e->getMessage());
        Log::Error($e->getTrace());
    }
}

//Main entry point
Main($argv);
?>