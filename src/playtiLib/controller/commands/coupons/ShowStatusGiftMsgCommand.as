package playtiLib.controller.commands.coupons
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.display.GeneralDialogsConfig;
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.controller.commands.popup.OpenPopupCommand;
	import playtiLib.model.VO.popup.SystemMsgVO;
	import playtiLib.utils.locale.TextLib;
	/**
	 * This class handles the gift msg status by (in execute) different cases of the notification's body.  
	 */	
	public class ShowStatusGiftMsgCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			
			var systemMsgVO:SystemMsgVO = new SystemMsgVO();
			systemMsgVO.has_close_btn 	= true;
			systemMsgVO.popup_name_mc 	= GeneralDialogsConfig.POPUP_GIFT_STATUS;
			
			var status_code:int	 		= int( notification.getBody() );
			
			switch( status_code ){ 
				case CouponSystemConfig.STATUS_MAX_COUNT_EXCEEDED: //max count exeeded
				case CouponSystemConfig.STATUS_INVALID_COUPON_STATE: //invalid coupon state
				case CouponSystemConfig.STATUS_NONUNIQUE_COUPON_TOKEN: //nonunique coupon token
				case CouponSystemConfig.STATUS_NO_ADMIN_USER_SPECIFIED_FOR_COUPON: //admin user is not specified for system_to_user coupon
				case CouponSystemConfig.STATUS_COUPON_ALREADY_COLLECTED: //coupon already collected  
				case CouponSystemConfig.STATUS_COULD_NOT_SEND_COUPON: //could not send coupon (is_user_specific_aknowlage = true)
					systemMsgVO.title = TextLib.lib.retrive( 'coupon.already_collected.title' ) as String;
					systemMsgVO.description = TextLib.lib.retrive( 'coupon.already_collected.desc' ) as String;
					sendNotification( GeneralAppNotifications.SYSTEM_MSG_POPUP, systemMsgVO, OpenPopupCommand.FORCE_OPEN );
					sendNotification( GeneralAppNotifications.LOAD_SOCIAL_REQUESTS );
					break;
				case CouponSystemConfig.STATUS_ALREADY_COLLECTED_COUPON_FROM_USER: //could not collect coupon today from the same user ..try to accept tomorrow
				case CouponSystemConfig.STATUS_SOME_COUPONS_ALREADY_COLLECTED:
				case CouponSystemConfig.STATUS_INACCEPTABLE_COUPON:
					systemMsgVO.title = TextLib.lib.retrive( 'coupon.already_collected_some.title' ) as String;
					systemMsgVO.description = TextLib.lib.retrive( 'coupon.already_collected_some.desc' ) as String;
					sendNotification( GeneralAppNotifications.SYSTEM_MSG_POPUP, systemMsgVO );
					break;
				case CouponSystemConfig.STATUS_UNKNOWN_ERROR: //unknown error
				case CouponSystemConfig.STATUS_UNKNOWN_COUPON: //unknown coupon
				case CouponSystemConfig.STATUS_REMOVED_COUPON: //coupon expired/removed
				case CouponSystemConfig.STATUS_COUPON_SENT_BY_MYSELF://could not collect user's own coupon sender_sn_id = p_user_sn_id
				case CouponSystemConfig.STATUS_COUPON_CANT_BE_COLLECTED:
					systemMsgVO.title = TextLib.lib.retrive( 'coupon.cant_collect.title' ) as String;
					systemMsgVO.description = TextLib.lib.retrive( 'coupon.cant_collect.desc' ) as String;
					sendNotification( GeneralAppNotifications.SYSTEM_MSG_POPUP, systemMsgVO );
					break;
				case CouponSystemConfig.STATUS_SOME_COUPONS_CANT_BE_COLLECTED:
					systemMsgVO.title = TextLib.lib.retrive( 'coupon.cant_collect_some.title' ) as String;
					systemMsgVO.description = TextLib.lib.retrive( 'coupon.cant_collect_some.desc' ) as String;
					sendNotification( GeneralAppNotifications.SYSTEM_MSG_POPUP, systemMsgVO );
					break;
//				case CouponSystemConfig.COUPON_SYSTEM_UNAVIABLE:
//					systemMsgVO.popup_name_mc = null;
//					systemMsgVO.title = TextLib.lib.retrive( 'coupon.coupon_system_unaviable.title' ) as String;
//					systemMsgVO.description = TextLib.lib.retrive( 'coupon.coupon_system_unaviable.desc' ) as String;
//					sendNotification( GeneralAppNotifications.SYSTEM_MSG_POPUP, systemMsgVO );
//					break;
				//coupon system is unavailable
				case CouponSystemConfig.STATUS_CUPON_SYSTEM_UNAVIABLE:
				case CouponSystemConfig.COUPON_UNKNOWN_ERROR:	
				case CouponSystemConfig.WARN_EVENT_IS_NOT_AVAILABLE:
				case CouponSystemConfig.COUPON_SYSTEM_UNAVIABLE:	
					systemMsgVO.popup_name_mc = GeneralDialogsConfig.POPUP_GIFTS_ARE_NOT_AVAILABLE;
					systemMsgVO.description = TextLib.lib.retrive( 'coupon.coupon_system_unaviable.desc' ) as String;
//					systemMsgVO.description = TextLib.lib.retrive( 'coupon.coupon_system_unaviable.title' ) as String;
					sendNotification( GeneralAppNotifications.SYSTEM_MSG_POPUP, systemMsgVO );
					break;
			}
		}
	}
}
//	list of errors that the coupon can has:

//				public static final int NO_ERROR = 0;
//				public static final int UNKNOWN_ERROR = 1000;
//				public static final int UNKNOWN_COUPON = 1001;
//				public static final int COUPON_EXPIRED_REMOVED = 1002;
//				public static final int MAX_COUNT_EXEEDED = 1003;
//				public static final int INVALID_COUPON_STATE = 1004;
//				public static final int NONUNIQUE_COUPON_TOKEN = 1005;
//				public static final int ADMIN_USR_IS_NOT_SPECIFIED_STU_COUPON = 1006;
//				public static final int COUPON_ALREADY_COLLECTED = 1007;
//				public static final int COULD_NOT_SEND_COUPON = 1008;
//				public static final int COULDNOT_COLLECT_COUPON_TODAY = 1009;
//				public static final int COULDNOT_COLLECT_OWN_COUPON = 1010;
//				public static final int COUPON_IS_NOT_AVAILABLE_NOW = 1011;