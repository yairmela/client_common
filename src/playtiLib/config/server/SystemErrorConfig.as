package playtiLib.config.server
{
	public class SystemErrorConfig
	{
		public static const ERROR_GET_CONTENT			:int = 1;
		public static const ERROR_GET_XML_CONTENT		:int = 2;
		public static const ERROR_GET_SWF_CONTENT		:int = 3;
		public static const ERROR_RELOGIN				:int = 4;
		public static const ERROR_IOERROR				:int = 5;
		
		public static const ERROR_SERVER_TRANSACTION_NOT_CREATED_YET	:int = -105;
		
		public static const ERROR_INVALID_GIFT_TOKEN		:int = -4;

		public static const ERROR_SERVER_SESSION_EXPIRE		:int = -11;
		public static const ERROR_SERVER_WRONG_MD5			:int = -12;
		public static const ERROR_SERVER_USER_NOT_FOUND		:int = -14;
		public static const ERROR_SERVER_SOME_ERROR			:int = -1;
		
		public static const LOGIN_NOT_ALLOWED_AT_THIS_MOMENT:int = 1201;		
	}
}