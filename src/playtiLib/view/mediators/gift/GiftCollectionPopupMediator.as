package playtiLib.view.mediators.gift
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.controller.commands.popup.OpenPopupCommand;
	import playtiLib.model.VO.amf.response.Coupon;
	import playtiLib.model.VO.gift.ChooseGift;
	import playtiLib.model.VO.gift.Gift;
	import playtiLib.model.VO.popup.PopupDoActionVO;
	import playtiLib.model.VO.social.SocialPostVO;
	import playtiLib.model.proxies.coupon.UserCouponProxy;
	import playtiLib.model.proxies.user.UserProxy;
	import playtiLib.model.proxies.user.UserSocialInfoProxy;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.utils.locale.TextLib;
	import playtiLib.view.components.btns.ButtonSimple;
	import playtiLib.view.components.gift.GiftCollectionViewLogic;
	import playtiLib.view.components.popups.PopupViewLogic;
	import playtiLib.view.mediators.popups.PopupMediator;
	
	public class GiftCollectionPopupMediator extends PopupMediator	{
		
		public static const NAME:String = 'giftcollectionPopupMediator';
		private var popupVLogic:GiftCollectionViewLogic;
		private var _forceUpdate:Boolean;
		private var _closeBtn:PopupDoActionVO;
		
		public function GiftCollectionPopupMediator( popupViewLogic:PopupViewLogic, forceUpdate:Boolean = false )	{
			
			
			super( NAME, popupViewLogic );	
			
			_forceUpdate 	= forceUpdate;
			popupVLogic 	= popupViewLogic as GiftCollectionViewLogic;
		}
		
		override public function onRegister():void { 
			
			super.onRegister();
			
			registerListeners();
//			force updating the coupons
			if( _forceUpdate ){
				getUsersSocialInfoAndInsertToGCP();
			}
			
}
		
		private function registerListeners():void {
			
			popupVLogic.addEventListener( CouponSystemConfig.SEND_BACK_BTN, giftBackHandler );
			popupVLogic.addEventListener( CouponSystemConfig.COLLECT_COUPON_BTN, collectHandler );
			popupVLogic.addEventListener( CouponSystemConfig.REMOVE_COUPON_BTN, removeHandler );
			popupVLogic.addEventListener( CouponSystemConfig.SEND_COUPON_BTN, sendGiftHandler );
			
		}
		
		private function get userCouponProxy():UserCouponProxy{
			
			return facade.retrieveProxy( UserCouponProxy.NAME ) as UserCouponProxy;
		}

		private function giftBackHandler( event:EventTrans ):void {
			
			var gift_mc:MovieClip 		= ( ( ( event.data) as MouseEvent ).currentTarget as ButtonSimple ).content.parent as MovieClip;
			var coupon:Coupon 	 		= popupVLogic.listWindow.GetItem( gift_mc.bg.count ).data as Coupon;
			var chooseGift:ChooseGift 	= new ChooseGift();
			chooseGift.friend_uid 		= coupon.senderSnId;
			
			var pre_gift:Gift	 		= new Gift();
			pre_gift.sender_sn_id 		= coupon.senderSnId;
			pre_gift.gift_type 			= coupon.giftTypeId;
			chooseGift.pre_gift 		= pre_gift;			
			sendNotification( GeneralAppNotifications.OPEN_SEND_GIFT_POPUP, chooseGift );
		}
		
		private function collectHandler( event:EventTrans ):void {
			
			( ( event.data) as MouseEvent ).currentTarget.enabled = false;
			var gift_mc:MovieClip 								= ( ( ( event.data) as MouseEvent ).target as ButtonSimple ).content.parent as MovieClip;
			var coupon:Coupon 									= popupVLogic.listWindow.GetItem( gift_mc.bg.count ).data as Coupon;
			
			gift_mc.gift_back_preloader.visible 				= true;
			gift_mc.collect_preloader.visible 					= true;
			gift_mc.reject_preloader.visible 					= true;
			
			var gift_mc_loop:MovieClip;
			for(var i:int=0; i< popupVLogic.listWindow.length; i++) {
				gift_mc_loop = popupVLogic.listWindow.GetItem(i).content.parent as MovieClip;
				gift_mc_loop.btn_collect.enabled = false;
				gift_mc_loop.btn_gift_back.removeEventListener( MouseEvent.CLICK, giftBackHandler );
				gift_mc_loop.btn_collect.removeEventListener( MouseEvent.CLICK, collectHandler );
				gift_mc_loop.btn_remove.removeEventListener( MouseEvent.CLICK, removeHandler );
			}
			sendNotification( GeneralAppNotifications.PRE_COLLECT_COUPON_COMMAND, coupon );
		}
		
		private function removeHandler( event:EventTrans ):void {
			
			var target_obj:Object =  ( ( event.data) as MouseEvent ).currentTarget;
			sendNotification( GeneralAppNotifications.OPEN_POPUP,
				new PopupMediator( "pop_up_reject_confirm", 
					new PopupViewLogic( "pop_up_reject_confirm" ), 
					new PopupDoActionVO( [GeneralAppNotifications.REJECT_COUPON_CONFIRM],[target_obj],null,[true] ),
					new PopupDoActionVO( [GeneralAppNotifications.REJECT_COUPON_CANCEL],[target_obj],null,[true] ) ),
				OpenPopupCommand.FORCE_OPEN );
		}
		
		private function sendGiftHandler( event:EventTrans ):void {
			
			sendNotification( GeneralAppNotifications.OPEN_SEND_GIFT_POPUP );
		}
		
		private function getUsersSocialInfoAndInsertToGCP():void{
			
			var coupons:Array = userCouponProxy.coupons;
			var usersIds:Array = coupons.map( function( item:Coupon, ...args):String { return item.senderSnId } );
			var usersSocialInfoList:Array = ( facade.retrieveProxy( UserSocialInfoProxy.NAME ) as UserSocialInfoProxy ).getAndLoadUserInfoByIds( usersIds );
			setCouponsMessage(coupons);
			popupVLogic.setCoupons(coupons, usersSocialInfoList );
		}
		
		private function setCouponsMessage( coupons:Array ):void{
			
			for each( var coupon:Coupon in coupons ){
				coupon.message = SocialPostVO.injectUserParamsToString( TextLib.lib.retrive('wall_posts.gifts.gift_'+coupon.giftTypeId+'.user_msg'), 
					user_proxy.user_level, user_proxy.userSocialInfo, [user_proxy.user_level.coinsGiftAmount] );
			}
		}

		private function onRejectConfirm( target_obj:Object ):void{
			
			var gift_mc:MovieClip;
			( target_obj as ButtonSimple ).enabled 	= false;
			gift_mc 								= ( target_obj as ButtonSimple ).content.parent as MovieClip;
			var rejectCoupon:Coupon 				= popupVLogic.listWindow.GetItem( gift_mc.bg.count ).data as Coupon;
			gift_mc.btn_collect.visible 			= false;
			gift_mc.btn_gift_back.visible 			= false;
			sendNotification( GeneralAppNotifications.REJECT_COUPON, rejectCoupon );
		}
		
		override public function handleNotification( notification:INotification ):void {
			
			var gift_mc:MovieClip;
			switch( notification.getName() ) {
				case GeneralAppNotifications.COUPON_REMOVED:
					if( !userCouponProxy.coupons.length ){
						closePopup();
					}
					break;
				case GeneralAppNotifications.COUPON_COLLECTED:
					if( !userCouponProxy.coupons.length ){
						closePopup();
					}else{
						popupVLogic.onCouponCollect( notification.getBody() as Coupon );
					}
					break;
				case GeneralAppNotifications.REJECT_COUPON_CONFIRM:
					onRejectConfirm( notification.getBody() );
					break;
				case GeneralAppNotifications.REJECT_COUPON_CANCEL:
					var target:Object = notification.getBody();
					target.enabled = true;;
					break;
				case GeneralAppNotifications.TODAY_RECEIVERS_READY:
					var recievers_ids:String = notification.getBody() as String;
					if ( recievers_ids!= null && recievers_ids.length > 0 ){
						popupVLogic.updateGiftBack(recievers_ids);
					}
					break;
				case GeneralAppNotifications.USER_COUPON_DATA_READY:
					getUsersSocialInfoAndInsertToGCP();
					break;
				default:
					throw Error( 'Unknow notification' );
					break;
			}
		}
		
		override public function listNotificationInterests():Array {
			
			return [GeneralAppNotifications.COUPON_REMOVED,
				GeneralAppNotifications.REJECT_COUPON_CONFIRM,
				GeneralAppNotifications.REJECT_COUPON_CANCEL,
				GeneralAppNotifications.COUPON_COLLECTED,
				GeneralAppNotifications.USER_COUPON_DATA_READY,
				GeneralAppNotifications.TODAY_RECEIVERS_READY];
		} 
		public function get user_proxy():UserProxy {
			return facade.retrieveProxy( UserProxy.NAME ) as UserProxy;
		}
	}
}