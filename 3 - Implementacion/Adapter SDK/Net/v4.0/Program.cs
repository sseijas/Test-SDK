// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Program.cs" company="Prisma">
//   Baufest(c) 2016
// </copyright>
// <summary>
//   Provides a command line utility
// </summary>
// --------------------------------------------------------------------------------------------------------------------
namespace Adapter
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.IO;
    using System.Text;

    /// <summary>
    /// The main class for command line utility
    /// </summary>
    public class Program
    {
        /// <summary>
        /// The Send authorize request method
        /// </summary>
        private const string SendRequest = "SendAuthorizeRequest";

        /// <summary>
        /// The Get authorize Answer
        /// </summary>
        private const string GetAnswer = "GetAuthorizeAnswer";

        /// <summary>
        /// The Get authorize Answer
        /// </summary>
        private const string GetStatus = "GetStatus";

        /// <summary>
        /// The payment flow complete 
        /// </summary>
        private const string PaymentFlow = "PaymentFlow";

        /// <summary>
        /// The list of available commands
        /// </summary>
        private static readonly List<string> AvailableCommands = new List<string>
            {
                SendRequest, GetAnswer, GetStatus, PaymentFlow
            };

        /// <summary>
        /// Gets or sets the input path
        /// </summary>
        private static string InputPath { get; set; }

        /// <summary>
        /// Gets or sets the output path
        /// </summary>
        private static string OutputPath { get; set; }

        /// <summary>
        /// Gets or sets the command
        /// </summary>
        private static string Command { get; set; }

        /// <summary>
        /// Gets or sets the xml Path for PaymentFlow command
        /// </summary>
        private static string XmlPath { get; set; }

        /// <summary>
        /// The initial method for command line utility
        /// </summary>
        /// <param name="args">The array of arguments</param>
        public static void Main(string[] args)
        {
            try
            {
                if (EvaluateParameters(args))
                {
                    Log.Title(string.Format("Starting {0} for file {1} ...", Command, Path.GetFileNameWithoutExtension(InputPath)));

                    WriteResponse(ExecuteCommand(LoadParameters()));
                }
            }
            catch (ConfigurationException ex)
            {
                Log.Error(ex.Message);
            }
            catch (NoResponseKeyException ex)
            {
                Log.Error(ex.Message);
                WriteResponse(ex.Context);
            }
            catch (FieldNotFoundException ex)
            {
                Log.Error(ex.Message + InputPath);
            }
            catch (Exception ex)
            {
                Log.Error(ex.Message);
                Log.Error(ex.StackTrace);
            }
        }

        /// <summary>
        /// Loads the parameters from input file
        /// </summary>
        /// <returns>The parameters loaded</returns>
        private static Dictionary<string, string> LoadParameters()
        {
            var parameters = new Dictionary<string, string>();
            var lines = File.ReadAllLines(InputPath);

            foreach (var line in lines)
            {
                if (string.IsNullOrEmpty(line) || line.StartsWith("//"))
                {
                    continue;
                }

                var keyValue = line.Split('=');

                if (keyValue.Length < 2)
                {
                    throw new ConfigurationException(string.Format("No value defined in [{0}] line of ini file.", line));
                }

                var value = keyValue[1].Trim().Equals("null", StringComparison.InvariantCultureIgnoreCase)
                                ? null
                                : keyValue[1].Trim();

                parameters.Add(keyValue[0].Trim(), value);
            }

            Log.Info(string.Format("File [{0}] has been loaded.", InputPath));
            return parameters;
        }

        /// <summary>Executes the command</summary>
        /// <param name="parameters">The dictionary of parameters</param>
        /// <returns>The response command.</returns>
        private static IEnumerable<KeyValuePair<string, object>> ExecuteCommand(IDictionary<string, string> parameters)
        {
            IEnumerable<KeyValuePair<string, object>> response = null;

            var connector = SdkServices.InitConnector(parameters);

            switch (Command)
            {
                case SendRequest:
                    response = SdkServices.ExecuteSendAuthorizeRequest(parameters, connector);
                    break;
                case GetAnswer:
                    response = SdkServices.ExecuteGetAuthorizeAnswer(parameters, connector);
                    break;
                case GetStatus:
                    response = SdkServices.ExecuteGetStatus(parameters, connector);
                    break;
                case PaymentFlow:
                    var res  = new Dictionary<string, object>
                        {
                            { SendRequest, SdkServices.ExecuteSendAuthorizeRequest(parameters, connector) },
                            { PaymentFlow, SdkServices.ExecutePaymentService(parameters, XmlPath) },
                            { GetAnswer, SdkServices.ExecuteGetAuthorizeAnswer(parameters, connector) }
                        };
                    response = res;
                    break;
            }

            Log.Info(string.Format("Command [{0}] has been executed.", Command));
            return response;
        }

        /// <summary>
        /// Writes the response to output file 
        /// </summary>
        /// <param name="message">The response message</param>
        private static void WriteResponse(IEnumerable<KeyValuePair<string, object>> message)
        {
            var buffer = new StringBuilder();

            WriteDictionary(message, buffer);

            File.WriteAllText(OutputPath, buffer.ToString());
            Log.Info(string.Format("File [{0}] has been written.", OutputPath));
        }

        /// <summary>
        /// Writes a dictionary into String Builder
        /// </summary>
        /// <param name="message">The dictionary to write</param>
        /// <param name="buffer">The buffer to contain the message</param>
        private static void WriteDictionary(IEnumerable<KeyValuePair<string, object>> message, StringBuilder buffer)
        {
            var item = message.GetEnumerator();
            while (item.MoveNext())
            {
                if (item.Current.Value is IEnumerable<KeyValuePair<string, object>>)
                {
                    buffer.Append("******************" + item.Current.Key + "****************************" + Environment.NewLine);
                    WriteDictionary((IEnumerable<KeyValuePair<string, object>>)item.Current.Value, buffer);
                    buffer.Append(Environment.NewLine);
                } 
                else
                {
                    buffer.Append(item.Current.Key).Append("=").Append(item.Current.Value).Append(Environment.NewLine);
                }
            }            
        }

        /// <summary>
        /// Evaluates and fills the program's parameters
        /// </summary>
        /// <param name="args">The array of arguments:
        /// For /SendAuthorizeRequest: c:SendAuthorizeRequest /i:.\Samples\Sample_01_SendRequest.ini /o:.\Samples\Sample_01_SendRequest.out
        /// For Payment flow: /c:PaymentFlow /i:.\Samples\Sample_01_PaymentFlow.ini /o:.\Samples\Sample_01_PaymentFlow.out /x:.\Samples\WS_Execute_Request.xml
        /// </param>
        /// <returns><b>True</b> if continue, <b>false</b> otherwise</returns>
        [SuppressMessage("StyleCop.CSharp.DocumentationRules", "SA1650:ElementDocumentationMustBeSpelledCorrectly", Justification = "Reviewed. Suppression is OK here.")]
        private static bool EvaluateParameters(IEnumerable<string> args)
        {
            foreach (var arg in args)
            {
                if (arg.StartsWith("/?"))
                {
                    Log.Info(
                        "Usage mode: >Adapter /c:{command} /i:{Path and file} /o:{Path and file} /x:{Path and File}");
                    Log.Info("Where:");
                    Log.Info("/c: The command name, must be one of following: " + string.Join(",", AvailableCommands));
                    Log.Info("/i: Path and filename for input file (command's parameters values file)");
                    Log.Info("/o: Path and filename for output file (command's response file)");
                    Log.Info("/x: Path and filename for xml payment service, requires for " + PaymentFlow + " command");
                    return false;
                }

                if (arg.StartsWith("/c:", StringComparison.InvariantCultureIgnoreCase))
                {
                    Command = arg.Substring(3);

                    if (!AvailableCommands.Contains(Command))
                    {
                        throw new ConfigurationException(string.Format("Command [{0}] is unrecognized.", Command));
                    }
                }
                else if (arg.StartsWith("/i:", StringComparison.InvariantCultureIgnoreCase))
                {
                    InputPath = arg.Substring(3);
                    InputPath = Path.Combine(Environment.CurrentDirectory, InputPath);
                    if (!File.Exists(InputPath))
                    {
                        throw new ConfigurationException(string.Format("File [{0}] not found.", InputPath));
                    }
                }
                else if (arg.StartsWith("/o:", StringComparison.InvariantCultureIgnoreCase))
                {
                    OutputPath = arg.Substring(3);
                    OutputPath = Path.Combine(Environment.CurrentDirectory, OutputPath);

                    if (!Directory.Exists(Path.GetDirectoryName(OutputPath)))
                    {
                        throw new ConfigurationException(string.Format("Path [{0}] not found.", OutputPath));
                    }
                }
                else if (arg.StartsWith("/x:", StringComparison.InvariantCultureIgnoreCase))
                {
                    XmlPath = arg.Substring(3);
                    XmlPath = Path.Combine(Environment.CurrentDirectory, XmlPath);
                    if (!File.Exists(XmlPath))
                    {
                        throw new ConfigurationException(string.Format("File [{0}] not found.", XmlPath));
                    }
                }
            }

            if (string.IsNullOrEmpty(Command))
            {
                throw new ConfigurationException(
                    string.Format("Command wasn't been configured, execute with /? for more information"));
            }

            if (string.IsNullOrEmpty(InputPath))
            {
                throw new ConfigurationException(
                    string.Format("InputPath wasn't been configured, execute with /? for more information"));
            }

            if (string.IsNullOrEmpty(OutputPath))
            {
                throw new ConfigurationException(
                    string.Format("OutputPath wasn't been configured, execute with /? for more information"));
            }

            if (string.IsNullOrEmpty(XmlPath) && Command.Equals(PaymentFlow))
            {
                throw new ConfigurationException(
                    string.Format("XmlPath wasn't been configured, execute with /? for more information"));
            }

            Log.Info("Configuration completed.");
            return true;
        }
    }
}