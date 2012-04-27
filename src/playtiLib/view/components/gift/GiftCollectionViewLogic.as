package playtiLib.view.components.gift
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.vo.amf.response.Coupon;
	import playtiLib.model.vo.gift.ChooseGift;
	import playtiLib.model.vo.gift.Gift;
	import playtiLib.model.vo.user.UserSocialInfo;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.view.components.btns.ButtonSimple;
	import playtiLib.view.components.list.ListWindowSimple;
	import playtiLib.view.components.popups.PopupViewLogic;
	
	public class GiftCollectionViewLogic extends PopupViewLogic {
		
		public var gifts_list:GiftsListVLogic;
		public var send_gift_btn:ButtonSimple;
		public var listWindow:ListWindowSimple;
		private var preloader_mc:MovieClip;
		private var loadAvatarIndex:int = -1;
		
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
				
		private function loadAvatar():void
		{
			loadAvatarIndex++;
			if (loadAvatarIndex>=listWindow.length) return;
			var coupon:Coupon = listWindow.GetItem(loadAvatarIndex).data as Coupon;
			var gift_mc:MovieClip = listWindow.GetItem(loadAvatarIndex).content.parent as MovieClip ;
			var avatar:Loader = new Loader();
			avatar.load( new URLRequest( coupon.sender.photo ) );
			gift_mc.avatar.addChild( avatar );
			avatar.contentLoaderInfo.addEventListener( Event.COMPLETE, onAvatarLoaded, false, 0, true );
			avatar.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onError, false, 0, true );
			avatar.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onError, false, 0, true );
		}
		
		private function onError (event:Event):void
		{
			loadAvatar();
		}
		
		private function inserUserSocialInfoToGift( userSocialInfo:UserSocialInfo ):void{
			
			listWindow = gifts_list.list.GetListWindow();
			var coupon:Coupon;
			var gift_mc:MovieClip;
			for( var i:int = 0 ; i < listWindow.length; i++ ) {
				coupon = listWindow.GetItem(i).data as Coupon;
				gift_mc = ( listWindow.GetItem(i).content.parent as MovieClip );
				if ( coupon.senderSnId == userSocialInfo.sn_id  ){
					coupon.sender = userSocialInfo;
					if( userSocialInfo.photo ){
						if (loadAvatarIndex<0) loadAvatar();
					}
					var nameField:TextField;
					
					nameField = gift_mc.name_txt;
					nameField.text = coupon.sender.first_name + ' ' + coupon.sender.last_name;
					
					var format:TextFormat = nameField.getTextFormat();
					
					while ((nameField.textWidth > nameField.width-3) && (int(format.size) >= 8)) {
						format.size = int(format.size) - 1;
						nameField.setTextFormat(format);
						format = nameField.getTextFormat();				
					}
										
					gift_mc.txt_info.text = coupon.message;
					
					gift_mc.gifts_generic_preloader.visible 	= false;
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
					gift_mc.gifts_generic_preloader.visible = false;

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
			
//			( event.currentTarget as ButtonSimple ).enabled = false;
//			waitAndSendEvent();
			var gift_mc:MovieClip 		= ( event.currentTarget as ButtonSimple ).content.parent as MovieClip;
			var coupon:Coupon 	 		= listWindow.GetItem( gift_mc.bg.count ).data as Coupon;
			var chooseGift:ChooseGift 	= new ChooseGift();
			chooseGift.friend_uid 		= coupon.senderSnId;
			
			var pre_gift:Gift	 		= new Gift();
			pre_gift.sender_sn_id 		= coupon.senderSnId;
			pre_gift.gift_type 			= coupon.giftTypeId;
			chooseGift.pre_gift 		= pre_gift;			
			
			dispatchEvent( new EventTrans( CouponSystemConfig.SEND_BACK_BTN, chooseGift ) );
		}
//		private function waitAndSendEvent():void{
//			setTimeout( function():void{dispatchEvent( new EventTrans( GeneralAppNotifications.UPDATE_TODAY_RECEIVERS ) ); }, 2000 );
//		}
		private function collectHandler(event:MouseEvent):void{
			
			event.currentTarget.enabled 			= false;
			var gift_mc:MovieClip 					= ( event.target as ButtonSimple ).content.parent as MovieClip;
			var coupon:Coupon 						= listWindow.GetItem( gift_mc.bg.count ).data as Coupon;
			
			gift_mc.gifts_generic_preloader.visible = true;
			
			var gift_mc_loop:MovieClip;
			for( var i:int = 0 ; i < listWindow.length; i++ ) {
				gift_mc_loop = listWindow.GetItem(i).content.parent as MovieClip;
				gift_mc_loop.btn_collect.enabled = false;
				gift_mc_loop.btn_gift_back.removeEventListener( MouseEvent.CLICK, giftBackHandler );
				gift_mc_loop.btn_collect.removeEventListener( MouseEvent.CLICK, collectHandler );
				gift_mc_loop.btn_remove.removeEventListener( MouseEvent.CLICK, removeHandler );
			}
			
			dispatchEvent( new EventTrans( CouponSystemConfig.COLLECT_COUPON_BTN, coupon ) );
		}
		
		private function removeHandler(event:MouseEvent):void{
			dispatchEvent( new EventTrans( CouponSystemConfig.REMOVE_COUPON_BTN, event ) );
		}
		
		public function onRejectConfirm( target_obj:Object ):void{
			
			var gift_mc:MovieClip;
			( target_obj as ButtonSimple ).enabled 	= false;
			gift_mc 								= ( target_obj as ButtonSimple ).content.parent as MovieClip;
			var rejectCoupon:Coupon 				= listWindow.GetItem( gift_mc.bg.count ).data as Coupon;
			gift_mc.btn_collect.visible 			= false;
			gift_mc.btn_gift_back.visible 			= false;
			
			dispatchEvent( new EventTrans( CouponSystemConfig.REMOVE_COUPON_BTN, rejectCoupon ) );
		}
		
		private function sendGiftHandler(event:MouseEvent):void{
			dispatchEvent( new EventTrans( CouponSystemConfig.SEND_COUPON_BTN, event ) );
		}

		private function onAvatarLoaded( event:Event ):void {
			var loader:Loader 	= event.currentTarget.loader;
			loader.y 			= ( 50-loader.height ) / 2;
			loadAvatar ();
		}
	}
}