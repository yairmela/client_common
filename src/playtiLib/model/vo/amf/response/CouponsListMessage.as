package playtiLib.model.vo.amf.response
{
	import mx.collections.ArrayCollection;

	public class CouponsListMessage extends ResultMessage{
		
		public var coupon:ArrayCollection/*Coupon*/;
		
		public function CouponsListMessage()	{
			
			super();
		}
	}
}