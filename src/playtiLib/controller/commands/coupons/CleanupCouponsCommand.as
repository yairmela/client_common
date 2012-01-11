package playtiLib.controller.commands.coupons
{
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.VO.amf.response.Coupon;
	/**
	 * Gets an array of coupons in the notification body and handles the coupons with errors. In some cases it sends a popup for the bad coupons, it also removes the Facebook 
	 * game request (if the error is different from cant collect today) and removes the coupon from the UserCouponProxy.
	 */
	public class CleanupCouponsCommand extends CouponCommand	{
		
		override public function execute( notification:INotification ):void{
			
			var errorCouponsList:Array = notification.getBody() as Array;
			
			if( notification.getType() == GeneralAppNotifications.CLEANUP_COUPONS_COMMAND ){
				handleGiftStatusMessages(errorCouponsList);
			}
			
			var is_some_message_showed:Boolean = false;
			for each ( var coupon:Coupon in errorCouponsList ){
				//if the user enters the app from FB request and force-open the gcp - need to see the error msg on screen
				if( ( notification.getType() == GeneralAppNotifications.COLLECT_COUPON_COMMAND )&& !is_some_message_showed ){
					is_some_message_showed = true;
					sendNotification( GeneralAppNotifications.SHOW_STATUS_GIFT_MSG, coupon.errorCode );	
				}
				
				if( coupon.errorCode != CouponSystemConfig.STATUS_SYSTEM_COPUON_CANT_COLLECT_TODAY )
					fb_request_proxy.removeCouponRequest( coupon.couponToken );
				
				if (coupon_proxy != null){
					coupon_proxy.removeCoupon(coupon.couponToken);
				}
			}
		}
		
		private function handleGiftStatusMessages( errorCouponsList:Array ):void{
			var link_request_ids:Array = (flashVars.request_ids != "" && flashVars.request_ids != "null" && flashVars.request_ids != null) ? flashVars.request_ids.split(',') : new Array();
			if (link_request_ids.length>0){
				var valid_requests_ids:Array = fb_request_proxy.request_ids;
				for (var i:int = 0 ; i<valid_requests_ids.length; i++){
					valid_requests_ids[i] = valid_requests_ids[i].slice(0,valid_requests_ids[i].indexOf('_') != -1 ? valid_requests_ids[i].indexOf('_') : valid_requests_ids[i].length-1 );
				}
				var invalid_link_request_ids:Array = link_request_ids.filter(function(element:String, ...args):Boolean{return valid_requests_ids.indexOf(element) == -1;});
				var priority_error_code:int = -1;
				
				
				var couponToken:String;
				if (link_request_ids.length == 1){
					if (invalid_link_request_ids.indexOf(link_request_ids[0]) == -1){
						couponToken = fb_request_proxy.getTokenById(link_request_ids[0]);
						for each ( var coupon_test1:Coupon in errorCouponsList ){
							if (coupon_test1.couponToken == couponToken){
								if (coupon_test1.errorCode != CouponSystemConfig.STATUS_SYSTEM_COPUON_CANT_COLLECT_TODAY){
									//1
									priority_error_code = CouponSystemConfig.STATUS_COUPON_CANT_BE_COLLECTED;
									//Gift cought not be collected 
								}else{
									//3
									priority_error_code = 0;
									//Gift already collected (cant collect this gift today)  --- ??????
								}
								break;
							}
						}
						if (priority_error_code==-1){
							priority_error_code = 0;
						}
					}else{
						//2					
						priority_error_code = CouponSystemConfig.STATUS_COUPON_CANT_BE_COLLECTED;
						//Gift cought not be collected 
					}
				}else{
					//4
					//5
					var already_collected_count:int = 0;
					var cought_not_be_collected_count:int = 0;
					for each (var request_id_test2:String in valid_requests_ids){
						couponToken = fb_request_proxy.getTokenById(request_id_test2);
						for each ( var coupon_test2:Coupon in errorCouponsList ){
							if (coupon_test2.couponToken == couponToken){
								//if (coupon_test2.errorCode == CouponSystemConfig.STATUS_SYSTEM_COPUON_CANT_COLLECT_TODAY || coupon_test2.errorCode == CouponSystemConfig.STATUS_COUPON_ALREADY_COLLECTED){
								if (coupon_test2.errorCode == CouponSystemConfig.STATUS_COUPON_ALREADY_COLLECTED){
									already_collected_count++;	
								}else{
									cought_not_be_collected_count++;
								}
							}  
						}
					}
					if (already_collected_count>0){
						priority_error_code = CouponSystemConfig.STATUS_SOME_COUPONS_ALREADY_COLLECTED;
						//if (already_collected_count == 1){
						//Some gift already collected
						//}else{
						//Some gifts already collected
						//}
					}else{
						if (cought_not_be_collected_count>0){
							priority_error_code = CouponSystemConfig.STATUS_SOME_COUPONS_CANT_BE_COLLECTED;
							//if (cought_not_be_collected_count == 1){
							//Some gift cought not be collected
							//}else{
							//Some gifts cought not be collected
							//}
						}
					}
					
					//6
					if (priority_error_code == -1 && invalid_link_request_ids.length>0){
						priority_error_code = CouponSystemConfig.STATUS_SOME_COUPONS_CANT_BE_COLLECTED;
						//if (invalid_link_request_ids.length == 1){
						//Some gift cought not be collected
						//}else{
						//Some gifts cought not be collected
						//}
					}
				}
				if (priority_error_code!=-1){
					sendNotification( GeneralAppNotifications.SHOW_STATUS_GIFT_MSG, priority_error_code );	
				}
			}
		}
	}
}