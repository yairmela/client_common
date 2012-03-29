package playtiLib.model.vo.amf.response.helpers
{
	import playtiLib.model.vo.user.RestrictedUserLevel;

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