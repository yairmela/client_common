package playtiLib.controller.commands.coupons
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.model.VO.amf.response.Coupon;
	import playtiLib.model.VO.amf.response.CouponsListMessage;
	import playtiLib.model.VO.social.SocialPostVO;
	import playtiLib.model.VO.social.user.SocialUserIdsVO;
	import playtiLib.model.VO.social.user.SocialUsersListVO;
	import playtiLib.model.VO.user.UserSocialInfo;
	import playtiLib.model.proxies.coupon.UserCouponProxy;
	import playtiLib.model.proxies.user.UserSocialInfoProxy;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.utils.locale.TextLib;
	import playtiLib.utils.time.TimeUtil;
	import playtiLib.view.components.user.FriendsListVLogic;

	public class GetAndValidateCouponCommand extends CouponCommand	{
		
		override public function execute( notification:INotification ):void {
			// we get and validate the coupons
			var couponToken:String/*String*/ = (notification.getBody() as Array).length > 0 ? (notification.getBody() as Array).toString(): "";
			// incase we already have UserCouponProxy meaning this is not the first load and no requests to validate
			if( facade.hasProxy( UserCouponProxy.NAME ) && couponToken.length == 0 ) {
				// notify data ready ( no changes )
				sendNotification( GeneralAppNotifications.USER_COUPON_DATA_READY, coupon_proxy.coupons.length );
				// exit command
				return;
			}
			// if we don't have userCouponsProxy we want to load all coupons else only validate the new
			var processAllCoupons :Boolean = !facade.hasProxy( UserCouponProxy.NAME ) ? true : false;
			
			var dataCapsule:DataCapsule = DataCapsuleFactory.getDataCapsule( 
				[AMFGeneralCallsConfig.GET_AND_VALIDATE_COUPONS.setRequestProperties({couponToken:couponToken}, {processAllCoupons:processAllCoupons} ), SocialCallsConfig.SOCIAL_APP_FRIENDS_IDS] );
			dataCapsule.addEventListener( Event.COMPLETE, onDataReady );
			dataCapsule.loadData();
		}
		 
		private function onDataReady( event:Event ):void {
			
			var dataCapsule:DataCapsule = event.currentTarget as DataCapsule;
			if ( CouponSystemConfig.isCouponSystemUnavailable( dataCapsule.getDataHolderByIndex(0).server_response.service.errorCode ) ){
				sendNotification( GeneralAppNotifications.COUPON_SYSTEM_UNAVIABLE );
				if ( request_ids.length > 0 && !fb_request_proxy.isInviteRequestById( ( request_ids[0] ) ) ){
					sendNotification( GeneralAppNotifications.SHOW_STATUS_GIFT_MSG, CouponSystemConfig.COUPON_SYSTEM_UNAVIABLE );
				}
				return;
			}	
			//get array of valid coupons
			var validCoupons:Array = ( dataCapsule.getDataHolderByIndex(0).data as CouponsListMessage ).coupon.toArray();
			var friendsListInfo:Array = ( dataCapsule.getDataHolderByIndex(1).data == null ) ? [] : ( dataCapsule.getDataHolderByIndex(1).data as SocialUserIdsVO ).ids;
			//if there is at least 1 coupon
			if( validCoupons.length > 0 ){
				filterOutNonFriendCoupons( validCoupons, friendsListInfo )
				handleCouponsErrors( validCoupons );
				//filter out the non valid coupons
				validCoupons = validCoupons.filter( 
					function( element:Coupon, ...args ):Boolean{
						return ( element.errorCode == 0 );
					} );
			}
			//filter out same sender on same day coupons
			if( validCoupons.length > 0 ){
				validCoupons = filterOutSameSender( validCoupons );
			}
			if( !facade.hasProxy( UserCouponProxy.NAME ) ) {
				//first load in this session, if there is a req id in the flash vars, force open the GCP
				facade.registerProxy( new UserCouponProxy( validCoupons ) );
				facade.registerProxy( new UserSocialInfoProxy() );
				sendNotification( GeneralAppNotifications.USER_COUPON_DATA_READY, validCoupons.length, ( request_ids.length > 0 ).toString() );
			} else {
				coupon_proxy.addCoupons( validCoupons );
			}
		}
		//filter out the duplicated coupons ( same sender && same day )
		private function filterOutSameSender( coupons:Array ):Array{
			
			//adding to array the coupons that already in userCouponProxy
			if(  facade.hasProxy( UserCouponProxy.NAME ) ){
				coupons =  coupons.concat( coupon_proxy.coupons );
			}
			
			//this array will contain swaps to be done after the filter proccess
			//it will determin according to the request_ids we got in flash vars
			var swapSameSenderCoupons:Array = [];
			//filter out the coupons that already has same sender from same date
			var result:Array = coupons.filter( 
				function( coupon:Coupon, index:int, arr:Array ):Boolean {
					var afterThisCoupon:Array = arr.slice(index+1,arr.length);
					afterThisCoupon = afterThisCoupon.filter(//filter out only users from same sn id to check if any
						function( firstCoupon:Coupon, ...args ):Boolean {
							return firstCoupon.senderSnId == coupon.senderSnId && TimeUtil.getDaysBetweenDates(firstCoupon.createdTs, coupon.createdTs) == 0
						});
					//check if current coupon is prefered upon the first one
					if( afterThisCoupon.length > 0 && isInRequestIds( coupon.couponToken ) ) {
						//insert to swaps list
						swapSameSenderCoupons.push({remove:afterThisCoupon[afterThisCoupon.length-1], add:coupon})
					}
					return afterThisCoupon.length == 0;
				} );
			//make the swap
			for each( var swap:Object in swapSameSenderCoupons ) {
				if (result.indexOf(swap.remove) !=-1){
					result[result.indexOf(swap.remove)] = swap.add;
				}
			}
			return result;
		}
		
		//handle all the coupons error and return a list with only valid coupons
		public function handleCouponsErrors( couponsList:Array ):void{
			var couponsErrorList:Array = couponsList.filter( 
				function( element:Coupon, ...args ):Boolean{
					return ( element.errorCode != 0 );
				} );
			if( couponsErrorList.length > 0 )
				sendNotification( GeneralAppNotifications.CLEANUP_COUPONS_COMMAND, couponsErrorList, is_first_load ? GeneralAppNotifications.CLEANUP_COUPONS_COMMAND : null );
		}
		
		//check if the coupon sender is user's friend
		private function filterOutNonFriendCoupons( couponsList:Array, appFriendIds:Array ):void {
			var isCouponSenderIsUserFriend:Boolean;
			
			for each( var coupon:Coupon in couponsList ) {
				for each( var id:String in appFriendIds ) {
					if( coupon.senderSnId == id ) {
						isCouponSenderIsUserFriend = true;
						break;
					}
				}
				//if there is a coupon that its sender is no longer user's friend
				if( !isCouponSenderIsUserFriend ){
					coupon.errorCode = CouponSystemConfig.STATUS_REMOVED_COUPON;//coupon expired removed	
				}
			}
		}
		
		private function get request_ids():Array {
			if( flashVars.request_ids != null && flashVars.request_ids != "" && flashVars.request_ids != "null" ) {
				return flashVars.request_ids.split(',');
			} else {
				return [];
			}
		}
		
		private function isInRequestIds( token:String ):Boolean {
			//efficient comes [req_id]+"_"+[reciver_id]
			var efficient_id:String = fb_request_proxy.getIdByToken(token);
			if( !efficient_id || efficient_id=="" )
				return false;
			//break id so we will take only id without reciver
			var breakId:Array = efficient_id.split("_");
			return request_ids.indexOf( breakId[0]  )>=0
		}
		private function get is_first_load():Boolean{
			return facade.hasProxy( UserCouponProxy.NAME ) ? false : true;
		}
	}
}