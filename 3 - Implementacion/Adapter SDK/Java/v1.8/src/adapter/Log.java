package adapter;

/**
 * 
 * @author EA0734
 * Writes log to System.out
 */
public class Log {

	/**
	 * Writes a title to output
	 * @param message string to be printed
	 */
	public static void title(String message){
		System.out.println(message.toUpperCase());		
	}

	/**
	 * Writes an info to output
	 * @param message string to be printed
	 */
	public static void info(String message){
		System.out.println("INFO:" + message);		
	}

	/**
	 * Writes an error to output
	 * @param message string to be printed
	 */
	public static void error(String message){
		System.out.println("ERROR:" + message);		
	}
}
