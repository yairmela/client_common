package playtiLib.model.VO.amf.request
{
	public class CouponRequest extends ClientRequest{
		
		public var couponId:int;
		public var couponToken:String;
		public var couponTypeId :int;
		public var friendsIds:String; 
		public var processAllCoupons:Boolean;
		
		public function CouponRequest()
		{
		}
	}
}