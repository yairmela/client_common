package playtiLib.controller.commands.social
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.SocialConfig;
	import playtiLib.controller.commands.coupons.CreateCouponCommand;
	import playtiLib.controller.commands.paypage.OpenPayPageCommand;
	import playtiLib.controller.commands.social.fb.*;
	import playtiLib.controller.commands.social.gift.ChooseSnUserToSendGiftCommand;
	import playtiLib.controller.commands.social.mm.*;
	import playtiLib.controller.commands.social.simulate.SimulateInstallCommand;
	import playtiLib.controller.commands.social.vk.*;
	import playtiLib.model.vo.social.SocialConfigVO;
	import playtiLib.utils.tracing.Logger;

	public class SocialRegisterCommandsCommand extends SimpleCommand
	{
		override public function execute(notification:INotification) : void {
			Logger.log("SocialRegisterCommandsCommand");
			var sociaConfigVO:SocialConfigVO = SocialConfigVO(notification.getBody());
			switch(sociaConfigVO.sn_type) {
				case SocialConfig.VK:
					facade.registerCommand( GeneralAppNotifications.SOCIAL_INVITE_FRIENDS, VKInviteFriendsCommand );
					facade.registerCommand( GeneralAppNotifications.SOCIAL_INIT_CONNECTIONS, VKInitConnectionsCommand );
					facade.registerCommand( GeneralAppNotifications.LOAD_INITIAL_ASSETS_COMPLETE, VKGameInstallCommand );
					facade.registerCommand( GeneralAppNotifications.SOCIAL_GAME_INSTALL_CHECK, VKGameInstallCommand );
					facade.registerCommand( GeneralAppNotifications.SETTINGS_CHECK, VKSettingsCheckCommand );
					facade.registerCommand( GeneralAppNotifications.BUY_SELECTED_AMOUNT, VKBuyChipsCommand);
					facade.registerCommand( GeneralAppNotifications.PUBLISH_TO_WALL_COMMAND, VKPublishToWallCommand);
					facade.registerCommand( GeneralAppNotifications.PUBLISH_TO_WALL_APPROVED, VKPublishToWallApprovedCommand);
					facade.registerCommand( GeneralAppNotifications.CHOOSE_SN_USER, ChooseSnUserToSendGiftCommand);
					facade.registerCommand( GeneralAppNotifications.PUBLISH_GIFT_COMMAND, VKPublishGiftCommand);
					facade.registerCommand( GeneralAppNotifications.OPEN_PAY_PAGE, VKOpenPayPageCommand );
					facade.registerCommand( GeneralAppNotifications.SET_SOCIAL_BANNERS, VKSetBannersCommand);
					break;

				case SocialConfig.FB:
					facade.registerCommand( GeneralAppNotifications.LOAD_INITIAL_ASSETS_COMPLETE, FBAssetsLoadCompleteCommand );
					facade.registerCommand( GeneralAppNotifications.SOCIAL_INIT_CONNECTIONS, FBInitConnectionsCommand );
					facade.registerCommand( GeneralAppNotifications.SOCIAL_INVITE_FRIENDS, InviteFriendsCommand );
					facade.registerCommand( GeneralAppNotifications.PUBLISH_TO_WALL_COMMAND, FBStreamPublishCommand );
					facade.registerCommand( GeneralAppNotifications.CHOOSE_SN_USER, FBChooseSnUserCommand);
					facade.registerCommand( GeneralAppNotifications.PUBLISH_TO_WALL_APPROVED, FBSendRequestApprovedCommand);
					facade.registerCommand( GeneralAppNotifications.CREATE_COUPON, CreateCouponCommand );
					facade.registerCommand( GeneralAppNotifications.PUBLISH_GIFT_COMMAND, FBSendGiftRequestCommand  );
					facade.registerCommand( GeneralAppNotifications.OPEN_PAY_PAGE, FBOpenPayPageCommand );
					facade.registerCommand( GeneralAppNotifications.PUBLISH_TO_WALL_APPROVED, FBPublishToWallApprovedCommand);
					facade.registerCommand( GeneralAppNotifications.ADD_APP_REQUEST, FBAddApprequestCommand);
					facade.registerCommand( GeneralAppNotifications.REMOVE_APP_REQUEST, FBRemoveAppRequestCommand);
					facade.registerCommand( GeneralAppNotifications.REQUEST_GET_GIFT_DATA, FBGetGiftCommand);
					facade.registerCommand( GeneralAppNotifications.REQUEST_DATA_RECEIVED, FBHandleRequestCommand);
					facade.registerCommand( GeneralAppNotifications.SOCIAL_LIKE_APP, FBLikeCommand);
					facade.registerCommand( GeneralAppNotifications.SOCIAL_LIKE_APP_CALLBACK, FBLikeCommand);
					facade.registerCommand( GeneralAppNotifications.SOCIAL_ACCEPT_SURPRISE_GIFT, FBAcceptSurpriseGift);
					facade.registerCommand( GeneralAppNotifications.CLOSE_INVITE_PROXY, CloseInviteProxyCommand );
					facade.registerCommand( GeneralAppNotifications.CLOSE_SEND_GIFTS_PROXY, CloseSendGiftProxyCommand );
					facade.registerCommand( GeneralAppNotifications.SHOW_GAME_TAB_COMMAND, ShowGameTabCommand );
					facade.registerCommand( GeneralAppNotifications.SHOW_GIFTS_TAB_COMMAND, ShowGiftsTabCommand );
					facade.registerCommand( GeneralAppNotifications.SHOW_INVITE_TAB_COMMAND, ShowInviteTabCommand );
					facade.registerCommand( GeneralAppNotifications.OPEN_SOCIAL_INVITE_FRIENDS_DIALOG, SendSocialInvitesCommand );
					facade.registerCommand( GeneralAppNotifications.POST_SOCIAL_ACTION, FBPostActionCommand );
					break;

				case SocialConfig.MM:
					facade.registerCommand( GeneralAppNotifications.LOAD_INITIAL_ASSETS_COMPLETE, MMInitConnectionsCommand );
					facade.registerCommand( GeneralAppNotifications.SOCIAL_INVITE_FRIENDS, MMInviteFriendsCommand );
					facade.registerCommand( GeneralAppNotifications.PUBLISH_TO_WALL_COMMAND, MMStreamPublishCommand );
					facade.registerCommand( GeneralAppNotifications.SOCIAL_GAME_INSTALL_CHECK, MMGameInstallCommand );
					facade.registerCommand( GeneralAppNotifications.PUBLISH_TO_WALL_COMMAND, MMPublishToWallCommand);
					facade.registerCommand( GeneralAppNotifications.PUBLISH_TO_WALL_APPROVED, MMPublishToWallApprovedCommand);
					facade.registerCommand( GeneralAppNotifications.PUBLISH_GIFT_COMMAND, MMPublishGiftCommand);
					facade.registerCommand( GeneralAppNotifications.SETTINGS_CHECK, MMSettingsCheckCommand );
					facade.registerCommand( GeneralAppNotifications.OPEN_PAY_PAGE, OpenPayPageCommand );
					facade.registerCommand( GeneralAppNotifications.CHOOSE_SN_USER, ChooseSnUserToSendGiftCommand);
					break;

				case SocialConfig.SIMULATE:
					facade.registerCommand( GeneralAppNotifications.SOCIAL_GAME_INSTALL_CHECK,  SimulateInstallCommand);
					break;
			}
		}
	}
}