/**
 * 
 */
package adapter;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import ar.com.todopago.api.TodoPagoConector;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

/**
 * @author sseijas
 *
 */
public final class Program {
	
	/**
	 * The Send authorize request method
	 */
	private static final String SEND_REQUEST = "SendAuthorizeRequest";

    /**
     * The Get authorize Answer
     */
	private static final String GET_ANSWER = "GetAuthorizeAnswer";

	/**
	 * The Get authorize Answer
	 */
	private static final String GET_STATUS = "GetStatus";

	/**
    * The payment flow complete 
    */
    private static final String PAYMENT_FLOW = "PaymentFlow";

    /**
     *  The list of available commands
     */
    private static final List<String> AVAILABLE_COMMANDS = Arrays.asList(
    		SEND_REQUEST, 
    		GET_ANSWER, 
    		GET_STATUS, 
    		PAYMENT_FLOW);
    
    /**
     * The command to execute
     */
	private static String command;
	
	/**
	 * The path of input file 
	 */
	private static String inputPath;
	
	/**
	 * The path of output file
	 */
	private static String outputPath;
	
	/***
	 * The path of xml data file
	 */
	private static String xmlPath;

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		
		try		
		{
			if (evaluateParameters(args)){				
								
				Log.title(String.format("Starting %s for file %s ...", getCommand(), getFileNameWithoutExtension()));
				
				writeResponse(
						executeCommand(
								loadParameters()));
			}
			
		}
		catch (ConfigurationException | FieldNotFoundException ex){
			Log.error(ex.getMessage());
		}
		catch (NoResponseKeyException ex){
			Log.error(ex.getMessage());
			writeResponse((Map<String, Object>)ex.getContext());
		}
		catch (Exception ex)
		{
			Log.error(ex.getMessage());
			ex.printStackTrace();
		}		
	}
	
	/**
	 * Evaluates and return the filename without extension inputPath
	 * @return the filename of Input Path
	 */
	private static String getFileNameWithoutExtension (){	
		String fname = Paths.get(getInputPath()).getFileName().normalize().toString();
		if (fname.contains(".")){
			fname = fname.split("\\.")[0];
		}
		return fname;
	}
	
	/**
	 * 
	 * @param args The application parameters
	 * @return <b>True</b> if parameters are correctly evaluated, <b>False</b> otherwise
	 * @throws ConfigurationException
	 */
    private static boolean evaluateParameters(final String[] args) throws ConfigurationException
    {
    	for (int i = 0; i < args.length; i++) {
    		String arg = args[i];
    		
            if (arg.startsWith("/?")) {
                Log.info(
                    "Usage mode: >Adapter /c:{command} /i:{Path and file} /o:{Path and file} /x:{Path and File}");
                Log.info("Where:");
                Log.info("/c: The command name, must be one of following: " + String.join(",", AVAILABLE_COMMANDS));
                Log.info("/i: Path and filename for input file (command's parameters values file)");
                Log.info("/o: Path and filename for output file (command's response file)");
                Log.info("/x: Path and filename for xml payment service, requires for " + PAYMENT_FLOW + " command");
                
                return false;
            }

            String currentDirectory = Paths.get(".").toAbsolutePath().normalize().toString();
            
            if (arg.startsWith("/c:") || arg.startsWith("/C:")) {
                setCommand(arg.substring(3));

                if (!AVAILABLE_COMMANDS.contains(getCommand())) {
                    throw new ConfigurationException(String.format("Command [%s] is unrecognized.", getCommand()));
                }
            } else if (arg.startsWith("/i:") || arg.startsWith("/I:")) {            	                
            	String p = Paths.get(currentDirectory, arg.substring(3)).normalize().toString();
            	setInputPath(p);
                        	
                if (!new File(getInputPath()).exists()) {
                    throw new ConfigurationException(String.format("File [%s] not found.", getInputPath()));
                }
            } else if (arg.startsWith("/o:") || arg.startsWith("/O:"))            {
                String p = Paths.get(currentDirectory, arg.substring(3)).normalize().toString();
            	setOutputPath(p);

                File f = new File(getOutputPath());
            	
                if (f.exists() && f.isDirectory())                {
                    throw new ConfigurationException(String.format("Path [%s] not found.", getOutputPath()));
                }
            } else if (arg.startsWith("/x:")  || arg.startsWith("/X:")) {
                String p = Paths.get(currentDirectory, arg.substring(3)).normalize().toString();
            	setXmlPath(p);
                        	
                if (!new File(getXmlPath()).exists())                {
                    throw new ConfigurationException(String.format("File [%s] not found.", getXmlPath()));
                }
            }
		}

    	if (getCommand() == null) {
            throw new ConfigurationException(
                String.format("Command wasn't been configured, execute with /? for more information"));
        }

        if (getInputPath() == null) {
            throw new ConfigurationException(
                String.format("InputPath wasn't been configured, execute with /? for more information"));
        }

        if (getOutputPath() == null) {
            throw new ConfigurationException(
                String.format("OutputPath wasn't been configured, execute with /? for more information"));
        }

        if (getXmlPath() == null && getCommand().equals(PAYMENT_FLOW)) {
            throw new ConfigurationException(
                String.format("XmlPath wasn't been configured, execute with /? for more information"));
        }
        Log.info("Configuration completed.");
        return true;
    }
    
    /**
     * Loads the parameters from input file
     * @return The parameters loaded
     * @throws IOException 
     * @throws ConfigurationException 
     */
    private static Map<String, String> loadParameters() throws IOException, ConfigurationException
    {    	
    	Map<String, String> map = new HashMap<String, String>();
		
		List<String> lines = Files.readAllLines(new File(getInputPath()).toPath());
		for (final String line: lines){
			if (!line.isEmpty() && !line.substring(0, 4).contains("//")){
				
    			String[] values = line.split("=");

    			if (values.length < 2){
    				throw new ConfigurationException(String.format("No value defined in [%s] line of ini file.", line));
    			}
    			
    			String fieldName = values[0].trim();
    			if (fieldName.equals("URL OK")){
    				fieldName = "URL_OK";
    			} else if (fieldName.equals("URL Error")){
    				fieldName = "URL_ERROR";
    			} else if (fieldName.equals("Encoding Method")){
    				fieldName = "EncodingMethod";
    			}
    			
    			String fieldValue = values[1].trim();
    			map.put(fieldName, fieldValue.equals("null") ? "" : fieldValue);
			}    			
		}    		
		
        Log.info(String.format("File [%s] has been loaded.", getCommand()));
        return map;
    }

    /**
     * Executes the command
     * @param parameters The dictionary of parameters
     * @return The response command
     * @throws FieldNotFoundException 
     * @throws NoResponseKeyException 
     * @throws IOException 
     */
    private static Map<String, Object> executeCommand(Map<String, String> parameters) throws FieldNotFoundException, NoResponseKeyException, IOException
    {
    	Map<String, Object> response = null;
    	
        TodoPagoConector connector;
		connector = SdkServices.initConnector(parameters);

        switch (getCommand())
        {
            case SEND_REQUEST:
                response = SdkServices.executeSendAuthorizeRequest(parameters, connector);
                break;
            case GET_ANSWER:
                response = SdkServices.executeGetAuthorizeAnswer(parameters, connector);
                break;
            case GET_STATUS:
                response = SdkServices.executeGetStatus(parameters, connector);
                break;
            case PAYMENT_FLOW:
                Map<String, Object> res  = new TreeMap<String, Object>();
                res.put("1." + SEND_REQUEST, SdkServices.executeSendAuthorizeRequest(parameters, connector));
                res.put("2." + PAYMENT_FLOW, SdkServices.executePaymentService(parameters, getXmlPath()));
                res.put("3." + GET_ANSWER, SdkServices.executeGetAuthorizeAnswer(parameters, connector));               
                response = res;
                break;
        }
		
        Log.info(String.format("Command [%s] has been executed.", getCommand()));
        return response;
    }

    /**
     * Writes the response to output file
     * @param message The response message
     * @throws IOException 
     */
    private static void writeResponse(Map<String, Object> message)
    {
        StringBuffer buffer = new StringBuffer();
        writeDictionary(message, buffer);
                
        File logFile = new File(getOutputPath());

		try {
			BufferedWriter  writer = new BufferedWriter(new FileWriter(logFile));
	        writer.write (buffer.toString());
	        writer.close();

		} catch (IOException e) {
			Log.error(e.getMessage());
			e.printStackTrace();
		}
		
        Log.info(String.format("File [%s] has been written.", getOutputPath()));
    }

    /**
     * Writes a dictionary into StringBuffer
     * @param message The dictionary to write
     * @param buffer The buffer to contain the message
     */
    private static void writeDictionary(Map<String, Object> message, StringBuffer buffer)
    {
    	for (Map.Entry<String, Object> item : message.entrySet())
    	{
    	    if (item.getValue() instanceof Map<?, ?>) {
                buffer.append("******************" + item.getKey() + "****************************\n");
                writeDictionary((Map<String, Object>)item.getValue(), buffer);
                buffer.append("\n");    	    	
    	    }
    	    else 
    	    {
    	    	buffer.append(item.getKey() + "=" + item.getValue() + "\n");    	    	
    	    }
    	}        
    }

	/**
	 * @return the command
	 */
	public static String getCommand() {
		return command;
	}

	/**
	 * @param command the command to set
	 */
	public static void setCommand(String command) {
		Program.command = command;
	}

	/**
	 * @return the inputPath
	 */
	public static String getInputPath() {
		return inputPath;
	}

	/**
	 * @param inputPath the inputPath to set
	 */
	public static void setInputPath(String inputPath) {
		Program.inputPath = inputPath;
	}

	/**
	 * @return the outputPath
	 */
	public static String getOutputPath() {
		return outputPath;
	}

	/**
	 * @param outputPath the outputPath to set
	 */
	public static void setOutputPath(String outputPath) {
		Program.outputPath = outputPath;
	}

	/**
	 * @return the xmlPath
	 */
	public static String getXmlPath() {
		return xmlPath;
	}

	/**
	 * @param xmlPath the xmlPath to set
	 */
	public static void setXmlPath(String xmlPath) {
		Program.xmlPath = xmlPath;
	}


}
