package playtiLib.view.components.gift
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.VO.amf.response.Coupon;
	import playtiLib.model.VO.social.SocialPostVO;
	import playtiLib.model.VO.user.UserSocialInfo;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.utils.locale.TextLib;
	import playtiLib.view.components.btns.ButtonSimple;
	import playtiLib.view.components.list.ListWindowSimple;
	import playtiLib.view.components.popups.PopupViewLogic;
	
	public class GiftCollectionViewLogic extends PopupViewLogic {
		
		public var gifts_list:GiftsListVLogic;
		public var send_gift_btn:ButtonSimple;
		public var listWindow:ListWindowSimple;
		private var preloader_mc:MovieClip;
		
		public function GiftCollectionViewLogic( popup_name:String ) {
			
			super( popup_name );
			gifts_list = new GiftsListVLogic( popup_mc['listGifts'] );
			
			send_gift_btn = new ButtonSimple( popup_mc['btn_send_gift'] );
			
			preloader_mc = ( popup_mc['games_preloader'] as MovieClip );
		}
		
		public function setCoupons( coupons:Array, usersSocialInfoList:Array ):void{
			
			if( preloader_mc && preloader_mc.parent )
				preloader_mc.parent.removeChild( preloader_mc );
			
			gifts_list.insertGifts( coupons );
			gifts_list.list.GetListWindow().currentItemIndex = 0;
			
			insertUserSocialInfoListToGift( usersSocialInfoList );
			//send btn in GCP
			send_gift_btn.addEventListener( MouseEvent.CLICK, sendGiftHandler );
		}
		
		public function insertUserSocialInfoListToGift( usersSocialInfoList:Array ):void {
			
			for each( var userSocialInfo:UserSocialInfo in usersSocialInfoList ){
				if( userSocialInfo.isReady ){
					inserUserSocialInfoToGift( userSocialInfo );
				}else{
					userSocialInfo.addEventListener( GeneralAppNotifications.USER_SOCIAL_INFO_READY, onUserSocialInfoReady );
				}
			}
		}
		
		public function onUserSocialInfoReady( event:Event ):void	{
			
			( event.currentTarget as UserSocialInfo ).removeEventListener( GeneralAppNotifications.USER_SOCIAL_INFO_READY, onUserSocialInfoReady );
			inserUserSocialInfoToGift( event.currentTarget as UserSocialInfo );
		}
		
		public function inserUserSocialInfoToGift( userSocialInfo:UserSocialInfo ):void{
			
			listWindow = gifts_list.list.GetListWindow();
			var coupon:Coupon;
			var gift_mc:MovieClip;
			for( var i:int = 0 ; i < listWindow.length; i++ ) {
				coupon = listWindow.GetItem(i).data as Coupon;
				gift_mc = ( listWindow.GetItem(i).content.parent as MovieClip );
				if ( coupon.senderSnId == userSocialInfo.sn_id  ){
					coupon.sender = userSocialInfo;
					if( userSocialInfo.photo ){
						var avatar:Loader = new Loader();
						avatar.load( new URLRequest( coupon.sender.photo ) );
						avatar.contentLoaderInfo.addEventListener( Event.COMPLETE, avatarLoaded );
						gift_mc.avatar.addChild( avatar );
					}
					gift_mc.name_txt.text = coupon.sender.first_name + ' ' + coupon.sender.last_name;
					
					gift_mc.txt_info.text = coupon.message;
					
					gift_mc.gift_back_preloader.visible 	= false;
					gift_mc.collect_preloader.visible 		= false;
					gift_mc.reject_preloader.visible 		= false;
				}
				var gift_back_btn:ButtonSimple = new ButtonSimple( gift_mc.btn_gift_back );
				if( !coupon.isGiftBackAllowed ) {
					gift_back_btn.enabled = false;
				}
				//add event listeners
				gift_back_btn.addEventListener( MouseEvent.CLICK, giftBackHandler );
				var collect_btn:ButtonSimple = new ButtonSimple( gift_mc.btn_collect );
				collect_btn.addEventListener( MouseEvent.CLICK, collectHandler );
				var remove_btn:ButtonSimple = new ButtonSimple( gift_mc.btn_remove );
				remove_btn.addEventListener( MouseEvent.CLICK, removeHandler );
			}
		} 
		
		public function onCouponCollect( coupon:Coupon ):void{
			
			var gift_mc:MovieClip;
			for( var i:int = 0 ; i < listWindow.length; i++ ) {
				var currentCoupon:Coupon = listWindow.GetItem(i).data as Coupon;
				if ( currentCoupon.couponId == coupon.couponId ){
					gift_mc 							= listWindow.GetItem(i).content.parent as MovieClip;
					gift_mc.gift_back_preloader.visible = false;
					gift_mc.collect_preloader.visible 	= false;
					gift_mc.reject_preloader.visible 	= false;
					var collect_btn:ButtonSimple 		= new ButtonSimple( gift_mc.btn_collect );
					collect_btn.enabled 				= false;
					gift_mc.btn_remove.visible 			= false;
					break;
				}
			}
		}
		
		public function updateGiftBack( receiversId:String ):void{
			listWindow = gifts_list.list.GetListWindow();
			var coupon:Coupon;
			var gift_mc:MovieClip;
			for( var i:int = 0 ; i < listWindow.length; i++ ) {
				gift_mc = ( listWindow.GetItem(i).content.parent as MovieClip );
				var gift_back_btn:ButtonSimple = new ButtonSimple( gift_mc.btn_gift_back );
				coupon = listWindow.GetItem(i).data as Coupon;
				if( !coupon.isGiftBackAllowed || isSnIdSentGiftToday( receiversId, coupon.senderSnId )  ) {
					gift_back_btn.enabled = false;
				}
			}
		}	
		
		private function isSnIdSentGiftToday( receivers:String, snId:String ):Boolean{
			return receivers.indexOf( snId ) > -1 ;
		}
		
		private function giftBackHandler(event:MouseEvent):void{
			dispatchEvent( new EventTrans( CouponSystemConfig.SEND_BACK_BTN, event ) );
		}
		
		private function collectHandler(event:MouseEvent):void{
			dispatchEvent( new EventTrans( CouponSystemConfig.COLLECT_COUPON_BTN, event ) );
		}
		
		private function removeHandler(event:MouseEvent):void{
			dispatchEvent( new EventTrans( CouponSystemConfig.REMOVE_COUPON_BTN, event ) );
		}
		
		private function sendGiftHandler(event:MouseEvent):void{
			dispatchEvent( new EventTrans( CouponSystemConfig.SEND_COUPON_BTN, event ) );
		}

		private function avatarLoaded( event:Event ):void {
			
			var loader:Loader 	= event.currentTarget.loader;
			loader.y 			= ( 50-loader.height ) / 2;
		}
	}
}