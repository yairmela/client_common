package playtiLib.model.vo.amf.response
{
	import playtiLib.model.vo.amf.response.helpers.UserInfo;
	import playtiLib.model.vo.amf.response.helpers.UserLevel;
	import playtiLib.model.vo.amf.response.helpers.UserStatus;

	public class UserInfoMessage extends ResultMessage
	{
		public var userStatus:UserStatus;
		public var userLevel:UserLevel;
		
		public var userInfo:UserInfo;
		
		public function UserInfoMessage()
		{
			super();
		}
	}
}