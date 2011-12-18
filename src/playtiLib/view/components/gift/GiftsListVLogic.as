package playtiLib.view.components.gift
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.VO.amf.response.Coupon;
	import playtiLib.model.VO.user.UserSocialInfo;
	import playtiLib.utils.warehouse.GraphicsWarehouseList;
	import playtiLib.view.components.btns.ButtonSimple;
	import playtiLib.view.components.list.AutoArrangeDisplayContainer;
	import playtiLib.view.components.list.ListBoxSimple;
	import playtiLib.view.interfaces.IViewLogic;

	/**
	 * Class that repre
	 */
	public class GiftsListVLogic implements IViewLogic{
		
		private var list_mc:MovieClip;
		public var list:ListBoxSimple;
		
		private static const COUPON_LIMIT:int = 250;
		
		public function GiftsListVLogic( list_mc:MovieClip ){
			
			this.list_mc = list_mc;
			list = new ListBoxSimple( list_mc );
		}
		
		public function insertGifts( gifts:Array ):void {
			
			var mask_mc:MovieClip =  list_mc['listItems']['viewportMask'] as MovieClip;
			var scrollable_content_mc:MovieClip =  list_mc['listItems']['scrollableContent'] as MovieClip;
			var content_con_mc:AutoArrangeDisplayContainer = new AutoArrangeDisplayContainer( mask_mc.width, scrollable_content_mc );
			var i:int = 0;
			for each( var coupon:Object in gifts ) {
				if ( i >= COUPON_LIMIT ) 
					break;
				var gift_mc:MovieClip = GraphicsWarehouseList.getAsset( 'mc_gifts_con' ) as MovieClip;
				gift_mc.gotoAndStop(  'gift_' + String( ( coupon as Coupon ).giftTypeId ) );
				mask_mc.width =  gift_mc.width;
				content_con_mc.addChild( gift_mc );
				(gift_mc.gift.bg as MovieClip).enabled = false;
				list.GetListWindow().AddItem( gift_mc.gift.bg ).data = coupon;
				gift_mc.gift.bg.count = i;
				i++;
			}
		}
		
		public function get content():DisplayObject	{
			
			return list_mc;
		}
	}
}