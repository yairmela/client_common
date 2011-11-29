package playtiLib.config.server
{
	/**
	 * This class configures the server response. It used for paypage.
	 * @see playtiLib.utils.data.DataCallConfig
	 * 
	 */	
	public class ServerCallConfig{
		
		public static var server_callback_format:String 			= CALLBACK_JSON_FORMAT;
		
		public static const CALLBACK_XML_FORMAT		:String 		= "XML";
		public static const CALLBACK_JSON_FORMAT	:String			= "JSON";
		// server response codes description:
		public static const SRC_USER_NOT_REGISTERED		:int 		= 1;
		public static const SRC_SUCCESS					:int 		= 0;
		public static const SRC_ERROR					:int 		= -1;
		public static const SRC_NO_CONNECTION			:int 		= -5000;
		
		// server response codes for GET_TRAN_STATUS:
		public static const TRANSACTION_STATUS_CREATED	:String 		= "CREATED";
		public static const TRANSACTION_STATUS_IN_PROGRESS	:String 	= "IN_PROGRESS";
		public static const TRANSACTION_STATUS_COMPLETED	:String 	= "COMPLETED";
		public static const TRANSACTION_STATUS_FAILED	:String 		= "FAILED";
		
		public static const TRANSACTION_STATUS_CANCELED	:String 		= "CANCELED";		
		public static const TRANSACTION_STATUS_NOT_ENOUGH_MONEY:String  = "NO_MONEY";
	}
}