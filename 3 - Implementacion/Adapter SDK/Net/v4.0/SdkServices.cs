// -----------------------------------------------------------------------
// <copyright file="SdkServices.cs" company="  Baufest(c) 2016">
//   Baufest(c) 2016
// </copyright>
// -----------------------------------------------------------------------

using System.Data;

namespace Adapter
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Net;
    using System.Net.Security;
    using System.Security.Cryptography.X509Certificates;
    using System.Text;
    using TodoPagoConnector;

    /// <summary>
    /// The SDK services adapter
    /// </summary>
    public class SdkServices
    {
        /// <summary>
        /// The service End point
        /// </summary>
        private const string EndPoint = "EndPoint";
        
        /// <summary>
        /// The authorization key
        /// </summary>
        private const string Authorization = "Authorization";
        
        /// <summary>
        /// The security key
        /// </summary>
        private const string Security = "Security";

        /// <summary>
        /// The session key
        /// </summary>
        private const string Session = "Session";

        /// <summary>
        /// The merchant key
        /// </summary>
        private const string Merchant = "Merchant";
        
        /// <summary>
        /// The Request key
        /// </summary>
        private const string RequestKey = "RequestKey";

        /// <summary>
        /// The public request  key
        /// </summary>
        private const string PublicRequestKey = "PublicRequestKey";

        /// <summary>
        /// The Answer key
        /// </summary>
        private const string AnswerKey = "AnswerKey";

        /// <summary>
        /// The url for ok
        /// </summary>
        private const string UrlOk = "URL OK";

        /// <summary>
        /// The url for error
        /// </summary>
        private const string UrlError = "URL Error";

        /// <summary>
        /// The encoding method
        /// </summary>
        private const string EncodingMethod = "Encoding Method";

        /// <summary>
        /// The payment End Point
        /// </summary>
        private const string PaymentEndPoint = "PaymentEndPoint";

        /// <summary>
        /// The operation Id
        /// </summary>
        private const string OperationId = "OPERATIONID";

        /// <summary>
        /// The Currency Code
        /// </summary>
        private const string CurrencyCode = "CURRENCYCODE";

        /// <summary>
        /// The amount value
        /// </summary>
        private const string Amount = "AMOUNT";

        /// <summary>
        /// The email client
        /// </summary>
        private const string EmailCliente = "EMAILCLIENTE";

        /// <summary>
        /// The CSBT City
        /// </summary>
        private const string CsbtCity = "CSBTCITY";

        /// <summary>
        /// The CSBT Country
        /// </summary>
        private const string CsbtCountry = "CSBTCOUNTRY";

        /// <summary>
        /// The CSBT Email
        /// </summary>
        private const string CsbtEmail = "CSBTEMAIL";

        /// <summary>
        /// The CSBT First Name
        /// </summary>
        private const string CsbtFirstName = "CSBTFIRSTNAME";

        /// <summary>
        /// The CSBT Last Name
        /// </summary>
        private const string CsbtLastName = "CSBTLASTNAME";

        /// <summary>
        /// The CSBT Phone Number
        /// </summary>
        private const string CsbtPhoneNumber = "CSBTPHONENUMBER";

        /// <summary>
        /// The CSBT Postal Code
        /// </summary>
        private const string CsbtPostalCode = "CSBTPOSTALCODE";

        /// <summary>
        /// The CSBT State
        /// </summary>
        private const string CsbtState = "CSBTSTATE";

        /// <summary>
        /// The CSBT Street 1
        /// </summary>
        private const string CsbtStreet1 = "CSBTSTREET1";

        /// <summary>
        /// The CSBT Street 2
        /// </summary>
        private const string CsbtStreet2 = "CSBTSTREET2";

        /// <summary>
        /// The CSBT Customer Id
        /// </summary>
        private const string CsbtCustomerId = "CSBTCUSTOMERID";

        /// <summary>
        /// The CSBT IP Address
        /// </summary>
        private const string CsbtIpAddress = "CSBTIPADDRESS";

        /// <summary>
        /// The CSPT currency
        /// </summary>
        private const string CsptCurrency = "CSPTCURRENCY";

        /// <summary>
        /// The CSPT Grand Total Amount
        /// </summary>
        private const string CsptGrandTotalAmount = "CSPTGRANDTOTALAMOUNT";

        /// <summary>
        /// The CSMDD 6
        /// </summary>
        private const string Csmdd6 = "CSMDD6";

        /// <summary>
        /// The CSMDD 7
        /// </summary>
        private const string Csmdd7 = "CSMDD7";

        /// <summary>
        /// The CSMDD 8
        /// </summary>
        private const string Csmdd8 = "CSMDD8";

        /// <summary>
        /// The CSMDD 9
        /// </summary>
        private const string Csmdd9 = "CSMDD9";

        /// <summary>
        /// The CSMDD 10
        /// </summary>
        private const string Csmdd10 = "CSMDD10";

        /// <summary>
        /// The CSMDD 11
        /// </summary>
        private const string Csmdd11 = "CSMDD11";

        /// <summary>
        /// The CSST City
        /// </summary>
        private const string CsstCity = "CSSTCITY";

        /// <summary>
        /// The CSST Country
        /// </summary>
        private const string CsstCountry = "CSSTCOUNTRY";

        /// <summary>
        /// The CSST Email
        /// </summary>
        private const string CsstEmail = "CSSTEMAIL";

        /// <summary>
        /// The CSST First Name
        /// </summary>
        private const string CsstFirstName = "CSSTFIRSTNAME";

        /// <summary>
        /// The CSST Last Name
        /// </summary>
        private const string CsstLastName = "CSSTLASTNAME";

        /// <summary>
        /// The CSST Phone Number
        /// </summary>
        private const string CsstPhoneNumber = "CSSTPHONENUMBER";

        /// <summary>
        /// The CSST Postal Code
        /// </summary>
        private const string CsstPostalCode = "CSSTPOSTALCODE";

        /// <summary>
        /// The CSST State
        /// </summary>
        private const string CsstState = "CSSTSTATE";

        /// <summary>
        /// The CSST Street 1
        /// </summary>
        private const string CsstStreet1 = "CSSTSTREET1";

        /// <summary>
        /// The CSST Street 2
        /// </summary>
        private const string CsstStreet2 = "CSSTSTREET2";

        /// <summary>
        /// The CSIT Product Code
        /// </summary>
        private const string CsitProductCode = "CSITPRODUCTCODE";

        /// <summary>
        /// The CSIT Product Description
        /// </summary>
        private const string CsitProductDescription = "CSITPRODUCTDESCRIPTION";

        /// <summary>
        /// The CSIT Product Name
        /// </summary>
        private const string CsitProductName = "CSITPRODUCTNAME";

        /// <summary>
        /// The CSIT Product SKU
        /// </summary>
        private const string CsitProductSku = "CSITPRODUCTSKU";

        /// <summary>
        /// The CSIT Total Amount
        /// </summary>
        private const string CsitTotalAmount = "CSITTOTALAMOUNT";

        /// <summary>
        /// The CSIT Quantity
        /// </summary>
        private const string CsitQuantity = "CSITQUANTITY";

        /// <summary>
        /// The CSIT Unit Price
        /// </summary>
        private const string CsitUnitPrice = "CSITUNITPRICE";

        /// <summary>
        /// The CSMD 12
        /// </summary>
        private const string Csmdd12 = "CSMDD12";

        /// <summary>
        /// The CSMD 13
        /// </summary>
        private const string Csmdd13 = "CSMDD13";

        /// <summary>
        /// The CSMD 14
        /// </summary>
        private const string Csmdd14 = "CSMDD14";

        /// <summary>
        /// The CSMD 15
        /// </summary>
        private const string Csmdd15 = "CSMDD15";

        /// <summary>
        /// The CSMD 16
        /// </summary>
        private const string Csmdd16 = "CSMDD16";

        /// <summary>
        /// Initializes the TP connector
        /// </summary>
        /// <param name="parameters">The dictionary parameters</param>
        /// <returns>A TP connector initialized</returns>
        public static TPConnector InitConnector(IDictionary<string, string> parameters)
        {
            var headers = new Dictionary<string, string>
                {
                    { Authorization, parameters[Authorization] }
                };

            return new TPConnector(parameters[EndPoint], headers);
        }

        /// <summary>
        /// Execute the GetStatus method
        /// </summary>
        /// <param name="parameters">The method parameters</param>
        /// <param name="connector">The initialized connector</param>
        /// <returns>The service response</returns>
        public static IEnumerable<KeyValuePair<string, object>> ExecuteGetStatus(IDictionary<string, string> parameters, TPConnector connector)
        {
            var merchant = parameters[Merchant];
            var operationId = parameters[OperationId];

            var res = connector.GetStatus(merchant, operationId);

            return res[0];
        }

        /// <summary>
        /// Executes the GetAuthorizeAnswer method
        /// </summary>
        /// <param name="parameters">The method parameters</param>
        /// <param name="connector">The initialized connector</param>
        /// <returns>The service response</returns>
        public static IEnumerable<KeyValuePair<string, object>> ExecuteGetAuthorizeAnswer(IDictionary<string, string> parameters, TPConnector connector)
        {
            var request = FillDictionary(
                parameters, new List<string> { Security, Session, Merchant, RequestKey, AnswerKey });

            ServicePointManager.ServerCertificateValidationCallback += ValidateCertificate;

            return connector.GetAuthorizeAnswer(request);
        }

        /// <summary>
        /// Executes the GetAuthorizeAnswer method
        /// </summary>
        /// <param name="parameters">The method parameters</param>
        /// <param name="connector">The initialized connector</param>
        /// <returns>The service response</returns>
        public static IEnumerable<KeyValuePair<string, object>> ExecuteSendAuthorizeRequest(IDictionary<string, string> parameters, TPConnector connector)
        {
            var request = FillDictionary(
                parameters, new List<string> { Security, Session, Merchant, UrlOk, UrlError, EncodingMethod });

            var payload = FillDictionary(
                parameters,
                new List<string>
                    {
                        Merchant.ToUpper(),
                        OperationId,
                        CurrencyCode,
                        Amount,
                        EmailCliente,
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
                        Csmdd16
                    });

            ServicePointManager.ServerCertificateValidationCallback += ValidateCertificate;

            var response = connector.SendAuthorizeRequest(request, payload);

            if (!response.ContainsKey(RequestKey))
            {
                throw new NoResponseKeyException(string.Format("SendAuthorizeRequest response didn't provide a value for {0}", RequestKey), response);
            }

            parameters.Add(RequestKey, (string)response[RequestKey]);

            if (!response.ContainsKey(PublicRequestKey))
            {
                throw new NoResponseKeyException(string.Format("SendAuthorizeRequest response didn't provide a value for {0}", PublicRequestKey), response);
            }

            parameters.Add(PublicRequestKey, (string)response[PublicRequestKey]);

            return response;
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
        public static IEnumerable<KeyValuePair<string, object>> ExecutePaymentService(IDictionary<string, string> parameters, string xmlFile)
        {
            var xmlPayload = LoadPaymentMessage(parameters, xmlFile);
            var request = (HttpWebRequest)WebRequest.Create(new Uri(parameters[PaymentEndPoint]));

            request.Method = "POST";
            request.ContentType = "application/xml";
            request.Accept = "text/xml;charset=\"utf-8\"";

            var byteData = Encoding.UTF8.GetBytes(xmlPayload);
            request.ContentLength = byteData.Length;

            using (var postStream = request.GetRequestStream())
            {
                postStream.Write(byteData, 0, byteData.Length);
            }

            string result;
            using (var response = request.GetResponse())
            {
                var reader = new StreamReader(response.GetResponseStream());
                result = reader.ReadToEnd();
                reader.Close();
            }

            parameters.Add(AnswerKey, RetrieveAnswerKey(result, parameters[UrlOk]));

            return new Dictionary<string, object> { { "XmlMessage", result } };
        }

        /// <summary>
        /// Emulates certificate validation returning true
        /// </summary>
        /// <param name="sender">The sender</param>
        /// <param name="certificate">The certificate</param>
        /// <param name="chain">The chain</param>
        /// <param name="sslPolicyErrors">The SSL policy errors</param>
        /// <returns>Always true</returns>
        private static bool ValidateCertificate(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
        {
            return true;
        }

        /// <summary>
        /// Recovery the values from required list into dictionary
        /// </summary>
        /// <param name="parameters">The loaded parameters</param>
        /// <param name="fields">The required fields</param>
        /// <returns> A new dictionary </returns>
        private static Dictionary<string, string> FillDictionary(IDictionary<string, string> parameters, IEnumerable<string> fields)
        {
            var res = new Dictionary<string, string>();
            foreach (var field in fields)
            {
                try
                {
                    res.Add(field, parameters[field]);
                }
                catch
                {
                    throw new FieldNotFoundException(string.Format("Field [{0}] wasn't been provided in data file ", field));
                }
            }

            return res;
        }

        /// <summary>
        /// Loads and compose web services payment message
        /// </summary>
        /// <param name="parameters">The parameters dictionary</param>
        /// <param name="xmlFile">The xml data file</param>
        /// <returns>The xml payment message</returns>
        private static string LoadPaymentMessage(IDictionary<string, string> parameters, string xmlFile)
        {
            var xmlPayload = File.ReadAllText(xmlFile);           

            xmlPayload = xmlPayload.Replace(Environment.NewLine, string.Empty);
            xmlPayload = xmlPayload.Replace("${" + Amount + "}", parameters[Amount]);
            xmlPayload = xmlPayload.Replace("${" + PublicRequestKey + "}", parameters[PublicRequestKey].Replace("t", string.Empty));

            return xmlPayload;
        }

        /// <summary>
        /// Retrieve the value of AnswerKey from xml message
        /// </summary>
        /// <param name="xmlResult">The xml message</param>
        /// <param name="urlOk">The success url</param>
        /// <returns>The value of answer key</returns>
        private static string RetrieveAnswerKey(string xmlResult, string urlOk)
        {
            string result;
            var pos = xmlResult.IndexOf(urlOk, StringComparison.InvariantCultureIgnoreCase);

            if (pos > 0)
            {
                pos += (urlOk + "?Answer=").Length;
                result = xmlResult.Substring(pos, 36);
            } 
            else
            {
                throw new NoResponseKeyException(
                    string.Format("No answer key as parameter of success url: [{0}]", urlOk),
                    new Dictionary<string, object> { { "xmlResult", xmlResult } });
            }

            return result;
        }
    }
}