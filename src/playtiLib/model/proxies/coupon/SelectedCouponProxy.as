package playtiLib.model.proxies.coupon
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.model.vo.amf.response.Coupon;
	/**
	 * Proxy that stores the coupon that was selected by the user for collecting it( it is used after the user press on collect coupon 
	 * in GCP in the preCollectCouponCommand).
	 */	
	public class SelectedCouponProxy extends Proxy	{
		
		public static const NAME:String = "SelectedCouponProxy"; 
		
		public function SelectedCouponProxy( coupon:Coupon )	{
			super( NAME, coupon );
		}
		
		public function set coupon( item:Coupon ):void{
			data = item;
		}
		
		public function get coupon():Coupon{
			return getData() as Coupon;
		}
	}
}