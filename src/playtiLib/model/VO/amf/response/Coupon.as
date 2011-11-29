package playtiLib.model.VO.amf.response
{
	import playtiLib.model.VO.user.UserSocialInfo;

	public class Coupon {
		
		public var sender:UserSocialInfo;
		public var couponId:int; 
		public var errorCode:int;	 	
		public var giftTypeId:int;	 
		public var isGiftBackAllowed:int;	
		public var isUserToUser:int;
		public var status:int;
		public var statusChangeTs:int;	
		public var couponTypeId:int;	
		public var collectedCount:int;
		public var createdDay:int;
		public var userUsageLimit:int;
		
		public var couponToken:String; 
		public var giftTypeValue:String;	
		public var senderSnId:String;	
		public var senderPhoto:String;
		public var message:String;
		public var senderName:String;
		public var senderFirstName:String;
		public var senderLastName:String;
		public var requestId:String;
		
		public var createdTs:Number;
		public var startTs:Date;
		public var expireTs:Date;

		public function Coupon(){
			
		}
	}
}