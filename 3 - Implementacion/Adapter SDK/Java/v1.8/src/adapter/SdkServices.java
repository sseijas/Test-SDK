/**
 * 
 */
package adapter;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import ar.com.todopago.api.*;
/**
 * @author EA0734
 *
 */
public class SdkServices {

	/**
	* The authorization key
	**/
	private static final String AUTHORIZATION = "Authorization";

	/**
	* The security key
	**/
	private static final String SECURITY = "Security";

	/**
	* The session key
	**/
	private static final String SESSION = ElementNames.Session;
	
	/**
	* The merchant key
	**/
	private static final String MERCHANT = "Merchant";
	
	/**
	* The Request key
	**/
	private static final String REQUEST_KEY = "RequestKey";
	
	/**
	* The public request  key
	**/
	private static final String PUBLIC_REQUEST_KEY = "PublicRequestKey";
	
	/**
	* The Answer key
	**/
	private static final String ANSWER_KEY = "AnswerKey";
	
	/**
	* The url for ok
	**/
	private static final String URL_OK = ElementNames.UrlOK;
	
	/**
	* The url for error
	**/
	private static final String URL_ERROR = ElementNames.UrlError;
	
	/**
	* The encoding method
	**/
	private static final String ENCODING_METHOD = ElementNames.EncodingMethod;
	
	/**
	* The payment End Point
	**/
	private static final String PAYMENT_END_POINT = "PaymentEndPoint";
	
	/**
	* The operation Id
	**/
	private static final String OPERATION_ID = "OPERATIONID";
	
	/**
	* The Currency Code
	**/
	private static final String CURRENCY_CODE = "CURRENCYCODE";
	
	/**
	* The amount value
	**/
	private static final String AMOUNT = "AMOUNT";
	
	/**
	* The email client
	**/
	private static final String EMAIL_CLIENTE = "EMAILCLIENTE";
	
	/**
	* The CSBT City
	**/
	private static final String CSBT_CITY = "CSBTCITY";
	
	/**
	* The CSBT Country
	**/
	private static final String CSBT_COUNTRY = "CSBTCOUNTRY";
	
	/**
	* The CSBT Email
	**/
	private static final String CSBT_EMAIL = "CSBTEMAIL";
	
	/**
	* The CSBT First Name
	**/
	private static final String CSBT_FIRST_NAME = "CSBTFIRSTNAME";
	
	/**
	* The CSBT Last Name
	**/
	private static final String CSBT_LAST_NAME = "CSBTLASTNAME";
	
	/**
	* The CSBT Phone Number
	**/
	private static final String CSBT_PHONE_NUMBER = "CSBTPHONENUMBER";
	
	/**
	* The CSBT Postal Code
	**/
	private static final String CSBT_POSTAL_CODE = "CSBTPOSTALCODE";
	
	/**
	* The CSBT State
	**/
	private static final String CSBT_STATE = "CSBTSTATE";
	
	/**
	* The CSBT Street 1
	**/
	private static final String CSBT_STREET1 = "CSBTSTREET1";
	
	/**
	* The CSBT Street 2
	**/
	private static final String CSBT_STREET2 = "CSBTSTREET2";
	
	/**
	* The CSBT Customer Id
	**/
	private static final String CSBT_CUSTOMER_ID = "CSBTCUSTOMERID";
	
	/**
	* The CSBT IP Address
	**/
	private static final String CSBT_IP_ADDRESS = "CSBTIPADDRESS";
	
	/**
	* The CSPT currency
	**/
	private static final String CSPT_CURRENCY = "CSPTCURRENCY";
	
	/**
	* The CSPT Grand Total Amount
	**/
	private static final String CSPT_GRAND_TOTAL_AMOUNT = "CSPTGRANDTOTALAMOUNT";
	
	/**
	* The CSMDD 6
	**/
	private static final String CSMDD6 = "CSMDD6";
	
	/**
	* The CSMDD 7
	**/
	private static final String CSMDD7 = "CSMDD7";
	
	/**
	* The CSMDD 8
	**/
	private static final String CSMDD8 = "CSMDD8";
	
	/**
	* The CSMDD 9
	**/
	private static final String CSMDD9 = "CSMDD9";
	
	/**
	* The CSMDD 10
	**/
	private static final String CSMDD10 = "CSMDD10";
	
	/**
	* The CSMDD 11
	**/
	private static final String CSMDD11 = "CSMDD11";
	
	/**
	* The CSST City
	**/
	private static final String CSST_CITY = "CSSTCITY";
	
	/**
	* The CSST Country
	**/
	private static final String CSST_COUNTRY = "CSSTCOUNTRY";
	
	/**
	* The CSST Email
	**/
	private static final String CSST_EMAIL = "CSSTEMAIL";
	
	/**
	* The CSST First Name
	**/
	private static final String CSST_FIRST_NAME = "CSSTFIRSTNAME";
	
	/**
	* The CSST Last Name
	**/
	private static final String CSST_LAST_NAME = "CSSTLASTNAME";
	
	/**
	* The CSST Phone Number
	**/
	private static final String CSST_PHONE_NUMBER = "CSSTPHONENUMBER";
	
	/**
	* The CSST Postal Code
	**/
	private static final String CSST_POSTAL_CODE = "CSSTPOSTALCODE";
	
	/**
	* The CSST State
	**/
	private static final String CSST_STATE = "CSSTSTATE";
	
	/**
	* The CSST Street 1
	**/
	private static final String CSST_STREET1 = "CSSTSTREET1";
	
	/**
	* The CSST Street 2
	**/
	private static final String CSST_STREET2 = "CSSTSTREET2";
	
	/**
	* The CSIT Product Code
	**/
	private static final String CSIT_PRODUCT_CODE = "CSITPRODUCTCODE";
	
	/**
	* The CSIT Product Description
	**/
	private static final String CSIT_PRODUCT_DESCRIPTION = "CSITPRODUCTDESCRIPTION";
	
	/**
	* The CSIT Product Name
	**/
	private static final String CSIT_PRODUCT_NAME = "CSITPRODUCTNAME";
	
	/**
	* The CSIT Product SKU
	**/
	private static final String CSIT_PRODUCT_SKU = "CSITPRODUCTSKU";
	
	/**
	* The CSIT Total Amount
	**/
	private static final String CSIT_TOTAL_AMOUNT = "CSITTOTALAMOUNT";
	
	/**
	* The CSIT Quantity
	**/
	private static final String CSIT_QUANTITY = "CSITQUANTITY";
	
	/**
	* The CSIT Unit Price
	**/
	private static final String CSIT_UNIT_PRICE = "CSITUNITPRICE";
	
	/**
	* The CSMD 12
	**/
	private static final String CSMDD12 = "CSMDD12";
	
	/**
	* The CSMD 13
	**/
	private static final String CSMDD13 = "CSMDD13";
	
	/**
	* The CSMD 14
	**/
	private static final String CSMDD14 = "CSMDD14";
	
	/**
	* The CSMD 15
	**/
	private static final String CSMDD15 = "CSMDD15";
	
	/**
	* The CSMD 16
	**/
	private static final String CSMDD16 = "CSMDD16";

    /**
     * Initializes the TP connector
     * @param parameters The dictionary parameters
     * @return A TP connector initialized
     * @throws MalformedURLException 
     */
    public static TodoPagoConector initConnector(Map<String, String> parameters) throws MalformedURLException
    {
        Map<String, List<String>> headers = new HashMap<String, List<String>>();
        
        headers.put(AUTHORIZATION, Collections.singletonList(parameters.get(AUTHORIZATION)));
                
        return new TodoPagoConector(TodoPagoConector.developerEndpoint, headers);
    }

    /**
     * Execute the GetStatus method
     * @param parameters The method parameters
     * @param connector The initialized connector
     * @return The service response
     */
    public static Map<String, Object> executeGetStatus(Map<String, String> parameters, TodoPagoConector connector)
    {
        Map<String, String> header = new HashMap<>();
        header.put(MERCHANT, parameters.get(MERCHANT));
        header.put(OPERATION_ID, parameters.get(OPERATION_ID));
        
        return connector.getStatus(header);
    }

    /**
     *  Executes the GetAuthorizeAnswer method
     * @param parameters The method parameters
     * @param connector  The initialized connector
     * @return The service response
     * @throws FieldNotFoundException
     */
    public static Map<String, Object> executeGetAuthorizeAnswer(Map<String, String> parameters, TodoPagoConector connector) throws FieldNotFoundException
    {
        Map<String, String> request = fillDictionary(
            parameters, 
            Arrays.asList(SESSION, MERCHANT, REQUEST_KEY, ANSWER_KEY));
        request.put(ElementNames.Security, parameters.get(SECURITY));
                
        return connector.getAuthorizeAnswer(request);
    }

	/**
	 * Executes the GetAuthorizeAnswer method
	 * @param parameters The method parameters
	 * @param connector The initialized connector
	 * @return The service response
	 * @throws FieldNotFoundException 
	 * @throws NoResponseKeyException 
	 */
    public static Map<String, Object> executeSendAuthorizeRequest(Map<String, String> parameters, TodoPagoConector connector) throws FieldNotFoundException, NoResponseKeyException
    {
        Map<String, String> request = fillDictionary(
            parameters, Arrays.asList(SESSION, MERCHANT, URL_OK, URL_ERROR, ENCODING_METHOD, OPERATION_ID, CURRENCY_CODE, AMOUNT, EMAIL_CLIENTE ));
        request.put(ElementNames.Security, parameters.get(SECURITY));        
        request.put("AVAILABLEPAYMENTMETHODSIDS", "1#194#43#45");
        request.put("PUSHNOTIFYENDPOINT", "");
        request.put("PUSHNOTIFYMETHOD", "");
        request.put("PUSHNOTIFYSTATES", "");
              
        Map<String, String> payload = fillDictionary(
            parameters,
            Arrays.asList( 
                    CSBT_CITY,
                    CSBT_COUNTRY,
                    CSBT_EMAIL,
                    CSBT_FIRST_NAME,
                    CSBT_LAST_NAME,
                    CSBT_PHONE_NUMBER,
                    CSBT_POSTAL_CODE,
                    CSBT_STATE,
                    CSBT_STREET1,
                    CSBT_STREET2,
                    CSBT_CUSTOMER_ID,
                    CSBT_IP_ADDRESS,
                    CSPT_CURRENCY,
                    CSPT_GRAND_TOTAL_AMOUNT,
                    CSMDD6,
                    CSMDD7,
                    CSMDD8,
                    CSMDD9,
                    CSMDD10,
                    CSMDD11,
                    CSST_CITY,
                    CSST_COUNTRY,
                    CSST_EMAIL,
                    CSST_FIRST_NAME,
                    CSST_LAST_NAME,
                    CSST_PHONE_NUMBER,
                    CSST_POSTAL_CODE,
                    CSST_STATE,
                    CSST_STREET1,
                    CSST_STREET2,
                    CSIT_PRODUCT_CODE,
                    CSIT_PRODUCT_DESCRIPTION,
                    CSIT_PRODUCT_NAME,
                    CSIT_PRODUCT_SKU,
                    CSIT_TOTAL_AMOUNT,
                    CSIT_QUANTITY,
                    CSIT_UNIT_PRICE,
                    CSMDD12,
                    CSMDD13,
                    CSMDD14,
                    CSMDD15,
                    CSMDD16
                ));

        Map<String, Object> response = connector.sendAuthorizeRequest(request, payload);

        if (response.get(REQUEST_KEY) == null) {
        	throw new NoResponseKeyException(String.format("SendAuthorizeRequest response didn't provide a value for %s", REQUEST_KEY), response);
        }
        
        parameters.put(REQUEST_KEY, (String)response.get(REQUEST_KEY));

        if (response.get(PUBLIC_REQUEST_KEY) == null) {
        	throw new NoResponseKeyException(String.format("SendAuthorizeRequest response didn't provide a value for %s", PUBLIC_REQUEST_KEY), response);
        }
        
        parameters.put(PUBLIC_REQUEST_KEY, (String)response.get(PUBLIC_REQUEST_KEY));

        return response;
    }

    /**
     * Executes the payment web services
     * @param parameters The dictionary parameters
     * @param xmlFile The XML File.
     * @return The service response
     * @throws NoResponseKeyException 
     * @throws IOException 
     */
    public static Map<String, Object> executePaymentService(Map<String, String> parameters, String xmlFile) throws NoResponseKeyException, IOException
    {
        String xmlPayload = loadPaymentMessage(parameters, xmlFile);
                
        URL url = new URL(parameters.get(PAYMENT_END_POINT));
        HttpURLConnection httpConn = (HttpURLConnection)url.openConnection();
        
        String SOAPAction = parameters.get(PAYMENT_END_POINT);
        httpConn.setRequestProperty("Content-Length", String.valueOf(xmlPayload.length()));
		httpConn.setRequestProperty("Content-Type", "application/soap+xml");
		httpConn.setRequestProperty("SOAPAction", SOAPAction);
		httpConn.setRequestMethod("POST");
		httpConn.setDoOutput(true);
		httpConn.setDoInput(true);
        				
		OutputStreamWriter out = new OutputStreamWriter( httpConn.getOutputStream());
		out.write(xmlPayload);
		out.close();

		String responseString = null;						
		String outputString = "";		
		
		BufferedReader in;
		if (httpConn.getResponseCode() == 200){
			in = new BufferedReader(new InputStreamReader(httpConn.getInputStream()));	
		} else {
			in = new BufferedReader(new InputStreamReader(httpConn.getErrorStream()));
		}
								 
		while ((responseString = in.readLine()) != null) {
			outputString = outputString + responseString;
		}
		        
        parameters.put(ANSWER_KEY, retrieveAnswerKey(outputString, parameters.get(URL_OK)));
        Map<String, Object> response = new HashMap<String, Object>();
        response.put("XmlMessage", outputString);
        return response;
    }
    
    /**
     * Recovery the values from required list into dictionary
     * @param parameters The loaded parameters
     * @param fields The required fields
     * @return  A new dictionary 
     * @throws FieldNotFoundException
     */
    private static Map<String, String> fillDictionary(Map<String, String> parameters, List<String> fields) throws FieldNotFoundException
    {
        Map<String, String> res = new HashMap<String, String>();
        Iterator<String> it = fields.iterator();
        
        while (it.hasNext()){
        	String key = it.next();
            try {            	
                res.put(key, parameters.get(key));
            }
            catch (Exception ex){
                throw new FieldNotFoundException(String.format("Field %s wasn't been provided in data file ", key));
            }        	
        }
        return res;
    }

    /**
     * Loads and compose web services payment message
     * @param parameters The parameters dictionary
     * @param xmlFile The XML payment message
     * @return The XML file loaded into String
     * @throws IOException 
     */
    private static String loadPaymentMessage(Map<String, String> parameters, String xmlFile) throws IOException
    {	
    	StringBuilder sb = new StringBuilder();
    	BufferedReader br = null;

    	br = new BufferedReader(new FileReader(xmlFile));	
        String line = br.readLine();          
        while (line != null) {
            sb.append(line);
            line = br.readLine();
        }
        br.close();
    	
    	String xmlPayload = sb.toString();           
        
        xmlPayload = xmlPayload.replace("${" + AMOUNT + "}", parameters.get(AMOUNT));
        xmlPayload = xmlPayload.replace("${" + PUBLIC_REQUEST_KEY + "}", 
        			parameters.get(PUBLIC_REQUEST_KEY).replace("t", ""));

        return xmlPayload;
    }

    /**
     * Retrieve the value of AnswerKey from XML message
     * @param xmlResult The XML message
     * @param urlOk The success URL
     * @return The value of answer key
     * @throws NoResponseKeyException
     */
    private static String retrieveAnswerKey(String xmlResult, String urlOk) throws NoResponseKeyException
    {
        String result;
        int pos = xmlResult.indexOf(urlOk);

        if (pos > 0)
        {
            pos += (urlOk + "?Answer=").length();
            result = xmlResult.substring(pos, pos + 36);
        } 
        else
        {
        	Map<String, Object> context = new HashMap<String, Object>();
        	context.put("xmlResult", xmlResult);
        	
            throw new NoResponseKeyException(String.format("No answer key as parameter of success url: %s", urlOk), context);
        }

        return result;
    }
}
