/**
 * 
 */
package adapter;

/**
 * @author EA0734
 *
 */
public class NoResponseKeyException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6059606624914696436L;

	
	/**
	 * @param message
	 */
	public NoResponseKeyException(String message, Object context) {
		super(message);
		setContext(context);
	}
	
	/**
	 * @return the context
	 */
	public Object getContext() {
		return context;
	}

	/**
	 * @param context the context to set
	 */
	public void setContext(Object value) {
		this.context = value;
	}

	private Object context;
}
