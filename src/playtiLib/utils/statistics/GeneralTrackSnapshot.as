package playtiLib.utils.statistics
{
	import playtiLib.model.vo.FlashVarsVO;
	import playtiLib.model.vo.amf.response.TransactionStatusMessage;
	import playtiLib.model.vo.amf.response.helpers.UserInfo;
	import playtiLib.model.vo.amf.response.helpers.UserLevel;
	
	public class GeneralTrackSnapshot
	{
		public var user_level : UserLevel;
		public var user_info : UserInfo;
		public var flash_vars : FlashVarsVO;
		
		public var friends_count : uint;
		public var invite_data : Object;
		public var publish_data : Object;
		public var menu_type : String;
		public var error_code : String;
		public var buy_type : String;
		public var transaction : TransactionStatusMessage;
		public var app_installed : Boolean;
	}
}