package playtiLib.model.VO.amf.response
{
	public class CouponMessage extends ResultMessage{
		
		public var coupon:Coupon;
		public var couponMessage:String;
		public var giftTypeValue:int; 
		
		public function CouponMessage()	{
			
			super();
		}
	}
}