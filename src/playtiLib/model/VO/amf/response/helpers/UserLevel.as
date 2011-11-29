package playtiLib.model.VO.amf.response.helpers
{
	import playtiLib.model.VO.user.RestrictedUserLevel;

	public class UserLevel extends RestrictedUserLevel
	{
//		public var level:int;
		
		public var nextLevelReward:Number;
		public var nextLevelExperience:Number;
		public var prevLevelExperience:Number;
		public var coinsGiftAmount:Number;
		public var lobbySkin : String;
		
		public function UserLevel()
		{
		}

	}
}