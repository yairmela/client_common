package playtiLib.config.server
{
	/**
	 * This class configures the server errors.
	 */	
	public class ServerErrorsConfig{ 
		
		public static const ERROR_GET_CONTENT			:int = 1;
		public static const ERROR_GET_XML_CONTENT		:int = 2;
		public static const ERROR_GET_SWF_CONTENT		:int = 3;
		public static const ERROR_RELOGIN				:int = 4;
		public static const ERROR_IOERROR				:int = 5;
		
		public static const ERROR_SERVER_TRANSACTION_NOT_CREATED_YET	:int = -105;
		
		public static const ERROR_INVALID_GIFT_TOKEN		:int = -4;
		
		//old error codes
		//public static const ERROR_SERVER_SESSION_EXPIRE	:int = -11;
		public static const ERROR_SERVER_WRONG_MD5			:int = -12;
		public static const ERROR_SERVER_USER_NOT_FOUND		:int = -14;
		public static const ERROR_SERVER_SOME_ERROR			:int = -1;
		
		public static const ERROR_SERVER_MAINTENANCE			:int = 201;
		public static const ERROR_COUPONS_MAINTENANCE			:int = 202;
		public static const ERROR_MISSIONS_MAINTENANCE			:int = 203;
		public static const ERROR_PLUGIN_MAINTENANCE			:int = 204;
		
		public static const ERROR_SERVER_SESSION_EXPIRE			:int = 5004;
		public static const ERROR_SERVER_SESSION_IS_INVALID		:int = 5005;
		public static const ERROR_SERVER_USER_HAS_FEW_SESSION	:int = 5006;
		
		public static const LOGIN_NOT_ALLOWED_AT_THIS_MOMENT:int = 1201;		
	}
}