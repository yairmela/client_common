package playtiLib.model.VO.user
{
	import playtiLib.model.VO.amf.response.helpers.UserInfo;
	import playtiLib.model.VO.amf.response.helpers.UserLevel;
	import playtiLib.model.VO.amf.response.helpers.UserStatus;

	public class User
	{
		public var userInfo:RestrictedUserInfo;
		public var userStatus:RestrictedUserStatus;
		public var userLevel:RestrictedUserLevel;
		public var userSocialInfo:UserSocialInfo;
		public var userPositionInLeaderBoard:int;
		
		public function User()
		{
			userInfo 	= new UserInfo();
			userStatus 	= new UserStatus();
			userLevel 	= new UserLevel();
		}
	}
}