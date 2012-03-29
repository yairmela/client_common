package playtiLib.model.vo.amf.response.helpers
{
	import playtiLib.model.vo.user.RestrictedUserInfo;

	public class UserInfo extends RestrictedUserInfo
	{
//		/** The user social network id. */
//		public var userSnId:String;
//		
		/** The user first name. */
		public var userFirstName:String;
		
		/** The user last name. */
		public var userLastName:String;
		
		/** The user birthday. */
		public var userBirthday:String;
		
		/** The user invoker id. */
		public var userInvokerId:String;
		
		/** The user invoker type. */
		public  var userInvokerType:int;
		
		/** The user poster id. */
		public var userPosterId:String;
		
		/** The user create ts. */
		public var userCreateTs:String;
		
		/** The user last login ts. */
		public var userLastLoginTs:Number;
		
		/** The gender. */
		public var gender:int;
		
		/** The email. */
		public var email:String;
		
		/** The special bonus Ts */
		public var lastSpecialBonusTs:int;
		
		/** The special bonus count */
		public var specialBonusCounter:int;
		
		/** The max special bonus count */
		public var maxSpecialBonusCounter:int;
		
		/** The city id */
		public var city:String;
		
		/** The country id */
		public var country:String;
		
		/** Is user like app */
		public var userLikesApp:Boolean;
		
		/** User friends count */
		public var friendsCount:int;
		
		public var locale:String;
		
		/** The timeTillNextDailyBonus sec */
		public var timeTillNextDailyBonus:Number;
		
		/** The dailyBonusCounter */
		public var dailyBonusCounter:int;
		public var dailyBonusMultiplier:int;
		public var dailyBonusFriendsPercentage:Number;
		
		public var lastMegaBonusTs:Number;
		
		public var TRPromptChecked:Boolean;
		
		public var accountToken:String;
		
		
		public function UserInfo()
		{
		}
		
		public function get isTRAccountSpecified() : Boolean
		{
			return accountToken && (accountToken != "0");
		}
	}
}