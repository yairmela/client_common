package playtiLib.model.VO.amf.response
{
	import playtiLib.model.VO.amf.response.helpers.UserInfo;
	import playtiLib.model.VO.amf.response.helpers.UserLevel;
	import playtiLib.model.VO.amf.response.helpers.UserStatus;

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