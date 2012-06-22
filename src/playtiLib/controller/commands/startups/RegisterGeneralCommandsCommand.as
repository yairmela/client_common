package playtiLib.controller.commands.startups
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.controller.commands.content.GetLocaleContentCommand;
	import playtiLib.controller.commands.coupons.AfterCollectCouponCommand;
	import playtiLib.controller.commands.coupons.ChooseGiftCompleteCommand;
	import playtiLib.controller.commands.coupons.CleanupCouponsCommand;
	import playtiLib.controller.commands.coupons.CollectCouponCommand;
	import playtiLib.controller.commands.coupons.CouponSystemUnavailableCommand;
	import playtiLib.controller.commands.coupons.CreateCouponCommand;
	import playtiLib.controller.commands.coupons.CreateEventCouponCommand;
	import playtiLib.controller.commands.coupons.GetAndValidateCouponCommand;
	import playtiLib.controller.commands.coupons.GetTodayReceiversCommand;
	import playtiLib.controller.commands.coupons.OpenGiftCollectionPopupCommand;
	import playtiLib.controller.commands.coupons.OpenSendGiftPopupCommand;
	import playtiLib.controller.commands.coupons.PreCollectCouponCommand;
	import playtiLib.controller.commands.coupons.RejectCouponCommand;
	import playtiLib.controller.commands.coupons.SendCouponCommand;
	import playtiLib.controller.commands.coupons.ShowStatusGiftMsgCommand;
	import playtiLib.controller.commands.coupons.SystemToUserCouponCollectionCommand;
	import playtiLib.controller.commands.coupons.UpdateTodayRecieversCommand;
	import playtiLib.controller.commands.load.ShowLoadingDialogByNameCommand;
	import playtiLib.controller.commands.paypage.BuyTransactionResultCommand;
	import playtiLib.controller.commands.paypage.CheckBuyTransactionStatusCommand;
	import playtiLib.controller.commands.popup.OpenPopupCommand;
	import playtiLib.controller.commands.popup.OpenURLCommand;
	import playtiLib.controller.commands.popup.ShowNextPopupCommand;
	import playtiLib.controller.commands.server.ServerLoginCompleteCommand;
	import playtiLib.controller.commands.social.ExecuteGeneralExternalCallCommand;
	import playtiLib.controller.commands.social.SocialActionCommand;
	import playtiLib.controller.commands.social.fb.CloseSendGiftProxyCommand;
	import playtiLib.controller.commands.social.fb.FBLoadSocialRequestsCommand;
	import playtiLib.controller.commands.social.fb.SendScreenshotCommand;
	import playtiLib.controller.commands.social.fb.ShowGameTabCommand;
	import playtiLib.controller.commands.sound.MuteSoundsCommand;
	import playtiLib.controller.commands.statistics.GeneralStatisticsTrackingCommand;
	import playtiLib.controller.commands.task.ClientTaskHandlerCommand;
	import playtiLib.controller.commands.task.GetTasksCommand;
	import playtiLib.controller.commands.user.RegisterNewUserCommand;
	import playtiLib.controller.commands.user.UpdateUserInfoCommand;
	import playtiLib.controller.commands.user.UserDataReadyCoreCommand;

	/**
	 * Registers commands (buy proccess, register user commands, sounds, popups and coupons) by the facade. 
	 */	
	public class RegisterGeneralCommandsCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			
			facade.registerCommand( GeneralAppNotifications.SHOW_LOADING_DIALOG_BY_NAME, ShowLoadingDialogByNameCommand );
			//buy proccess
			facade.registerCommand( GeneralAppNotifications.BUY_RESULT, BuyTransactionResultCommand );
			facade.registerCommand( GeneralAppNotifications.CHECK_BUY_STATUS, CheckBuyTransactionStatusCommand );
			//register user commands
			facade.registerCommand( GeneralAppNotifications.SERVER_LOGIN_COMPLETE, ServerLoginCompleteCommand );
			facade.registerCommand( GeneralAppNotifications.REGISTER_NEW_USER, RegisterNewUserCommand );
			facade.registerCommand( GeneralAppNotifications.UPDATE_USER_INFO, UpdateUserInfoCommand );
			facade.registerCommand( GeneralAppNotifications.USER_DATA_READY, UserDataReadyCoreCommand );
			//sounds
			facade.registerCommand( GeneralAppNotifications.MUTE_SOUNDS, MuteSoundsCommand );
			//popups
			facade.registerCommand( GeneralAppNotifications.SHOW_NEXT_POPUP, ShowNextPopupCommand );
			facade.registerCommand( GeneralAppNotifications.OPEN_POPUP, OpenPopupCommand );
			facade.registerCommand( GeneralAppNotifications.SHOW_STATUS_GIFT_MSG, ShowStatusGiftMsgCommand );
			//coupons
			facade.registerCommand( GeneralAppNotifications.CHOOSE_GIFT_COMPLETE, ChooseGiftCompleteCommand );
			facade.registerCommand( GeneralAppNotifications.REJECT_COUPON, RejectCouponCommand );
			facade.registerCommand( GeneralAppNotifications.OPEN_GIFT_COLLECTION_POPUP, OpenGiftCollectionPopupCommand );
			facade.registerCommand( GeneralAppNotifications.OPEN_SEND_GIFT_POPUP, OpenSendGiftPopupCommand );
			facade.registerCommand( GeneralAppNotifications.CREATE_COUPON_NOTIFICATION, CreateCouponCommand );
			facade.registerCommand( GeneralAppNotifications.COLLECT_COUPON_COMMAND, CollectCouponCommand );
			facade.registerCommand( GeneralAppNotifications.PRE_COLLECT_COUPON_COMMAND, PreCollectCouponCommand );
			facade.registerCommand( GeneralAppNotifications.AFTER_COLLECT_COUPON_COMMAND, AfterCollectCouponCommand );
			facade.registerCommand( GeneralAppNotifications.SEND_COUPON_COMMAND, SendCouponCommand );
			facade.registerCommand( GeneralAppNotifications.LOAD_SOCIAL_REQUESTS, FBLoadSocialRequestsCommand );
			facade.registerCommand( GeneralAppNotifications.GET_AND_VALIDATE_COUPONS, GetAndValidateCouponCommand );
			facade.registerCommand( GeneralAppNotifications.CLEANUP_COUPONS_COMMAND, CleanupCouponsCommand );
			facade.registerCommand( GeneralAppNotifications.GET_TODAY_RECEIVERS_COMMAND, GetTodayReceiversCommand );
			facade.registerCommand( GeneralAppNotifications.SYSTEM_TO_USER_COUPON_COLLECTION, SystemToUserCouponCollectionCommand );
			facade.registerCommand( GeneralAppNotifications.UPDATE_TODAY_RECEIVERS, UpdateTodayRecieversCommand );
			facade.registerCommand( GeneralAppNotifications.CREATE_EVENT_COUPON_COMMAND, CreateEventCouponCommand );
			facade.registerCommand( GeneralAppNotifications.COUPON_SYSTEM_UNAVAILABLE, CouponSystemUnavailableCommand);
			//tasks
			facade.registerCommand( GeneralAppNotifications.GET_TASKS_COMMAND, GetTasksCommand );
			facade.registerCommand( GeneralAppNotifications.TASK_HANDLER, ClientTaskHandlerCommand );			

			facade.registerCommand( GeneralAppNotifications.EXECUTE_EXTERNAL_CALL, ExecuteGeneralExternalCallCommand );
			
			facade.registerCommand( GeneralAppNotifications.TRACK, GeneralStatisticsTrackingCommand );
			
			facade.registerCommand( GeneralAppNotifications.OPEN_URL, OpenURLCommand );
			facade.registerCommand(GeneralAppNotifications.LOAD_NEW_LOCALE_CONTENT, GetLocaleContentCommand);
			
			facade.registerCommand(GeneralAppNotifications.SCREENSHOT_MADE, SendScreenshotCommand);
			
			facade.registerCommand( GeneralAppNotifications.SOCIAL_ACTION, SocialActionCommand );
		}
	}
}
