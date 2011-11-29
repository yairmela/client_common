package playtiLib.utils.statistics
{
	import flash.utils.flash_proxy;
	
	import playtiLib.model.VO.FlashVarsVO;
	import playtiLib.model.VO.amf.response.TransactionStatusMessage;
	import playtiLib.model.VO.amf.response.helpers.UserInfo;
	import playtiLib.model.VO.amf.response.helpers.UserLevel;
	import playtiLib.model.VO.user.UserSocialInfo;
	
	public class TrackSnapshot
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
		
		public function TrackSnapshot( user_level : UserLevel, user_info : UserInfo, flash_vars : FlashVarsVO, dynamic_data : Object = null )
		{
			this.user_level = user_level;
			this.user_info = user_info;
			this.flash_vars = flash_vars;
			
			if(!dynamic_data) {
				return;
			}
			
			for(var field : String in dynamic_data) {
				switch(field) {
					case "friends_count":
						friends_count = dynamic_data[field];
						break;
					
					case "invite_data":
						invite_data = dynamic_data[field];
						break;
						
					case "publish_data":
						publish_data = dynamic_data[field];
						break;
						
					case "menu_type":
						menu_type = dynamic_data[field];
						break;
						
					case "error_code":
						error_code = dynamic_data[field];
						break;	
					
					case "buy_type":
						buy_type = dynamic_data[field];
						break;		
					
					case "transaction":
						transaction = dynamic_data[field];
						break;
					
					case "app_installed":
						app_installed = dynamic_data[field];
						break;
					
					default:
						throw new ArgumentError("Unknown \""+field+"\" property passed.");
						return;
				}
			}
		}
	}
}