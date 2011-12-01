package playtiLib.controller.commands.social
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.config.social.SocialConfig;
	import playtiLib.config.social.mm.MMNotifications;
	import playtiLib.config.social.vk.VKNotifications;
	import playtiLib.controller.commands.coupons.CreateCouponCommand;
	import playtiLib.controller.commands.paypage.OpenPayPageCommand;
	import playtiLib.controller.commands.social.fb.FBAddApprequestCommand;
	import playtiLib.controller.commands.social.fb.FBAssetsLoadCompleteCommand;
	import playtiLib.controller.commands.social.fb.FBChooseSnUserCommand;
	import playtiLib.controller.commands.social.fb.FBGetGiftCommand;
	import playtiLib.controller.commands.social.fb.FBHandleRequestCommand;
	import playtiLib.controller.commands.social.fb.FBInitConnectionsCommand;
	import playtiLib.controller.commands.social.fb.FBInviteFriendsCommand;
	import playtiLib.controller.commands.social.fb.FBLikeCommand;
	import playtiLib.controller.commands.social.fb.FBOpenPayPageCommand;
	import playtiLib.controller.commands.social.fb.FBPublishToWallApprovedCommand;
	import playtiLib.controller.commands.social.fb.FBRemoveAppRequestCommand;
	import playtiLib.controller.commands.social.fb.FBSendRequestApprovedCommand;
	import playtiLib.controller.commands.social.fb.FBSendRequestCommand;
	import playtiLib.controller.commands.social.fb.FBStreamPublishCommand;
	import playtiLib.controller.commands.social.gift.ChooseSnUserToSendGiftCommand;
	import playtiLib.controller.commands.social.mm.MMGameInstallCommand;
	import playtiLib.controller.commands.social.mm.MMInitConnectionsCommand;
	import playtiLib.controller.commands.social.mm.MMInviteFriendsCommand;
	import playtiLib.controller.commands.social.mm.MMPublishGiftCommand;
	import playtiLib.controller.commands.social.mm.MMPublishToWallApprovedCommand;
	import playtiLib.controller.commands.social.mm.MMPublishToWallCommand;
	import playtiLib.controller.commands.social.mm.MMSettingsCheckCommand;
	import playtiLib.controller.commands.social.mm.MMStreamPublishCommand;
	import playtiLib.controller.commands.social.simulate.SimulateInstallCommand;
	import playtiLib.controller.commands.social.vk.VKBuyChipsCommand;
	import playtiLib.controller.commands.social.vk.VKGameInstallCommand;
	import playtiLib.controller.commands.social.vk.VKInitConnectionsCommand;
	import playtiLib.controller.commands.social.vk.VKInviteFriendsCommand;
	import playtiLib.controller.commands.social.vk.VKOpenPayPageCommand;
	import playtiLib.controller.commands.social.vk.VKPublishGiftCommand;
	import playtiLib.controller.commands.social.vk.VKPublishToWallApprovedCommand;
	import playtiLib.controller.commands.social.vk.VKPublishToWallCommand;
	import playtiLib.controller.commands.social.vk.VKSetBannersCommand;
	import playtiLib.controller.commands.social.vk.VKSettingsCheckCommand;
	import playtiLib.model.VO.social.SocialConfigVO;
	import playtiLib.utils.social.vk.VkWrapperUtil;
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
					facade.registerCommand( GeneralAppNotifications.SOCIAL_INVITE_FRIENDS, FBInviteFriendsCommand );
					facade.registerCommand( GeneralAppNotifications.PUBLISH_TO_WALL_COMMAND, FBStreamPublishCommand );
					facade.registerCommand( GeneralAppNotifications.CHOOSE_SN_USER, FBChooseSnUserCommand);
					facade.registerCommand( GeneralAppNotifications.PUBLISH_TO_WALL_APPROVED, FBSendRequestApprovedCommand);
					facade.registerCommand( GeneralAppNotifications.PUBLISH_GIFT_COMMAND, CreateCouponCommand );
					facade.registerCommand( GeneralAppNotifications.OPEN_PAY_PAGE, FBOpenPayPageCommand );
					facade.registerCommand( GeneralAppNotifications.PUBLISH_TO_WALL_APPROVED, FBPublishToWallApprovedCommand);
					facade.registerCommand( GeneralAppNotifications.ADD_APP_REQUEST, FBAddApprequestCommand);
					facade.registerCommand( GeneralAppNotifications.REMOVE_APP_REQUEST, FBRemoveAppRequestCommand);
					facade.registerCommand( GeneralAppNotifications.REQUEST_GET_GIFT_DATA, FBGetGiftCommand);
					facade.registerCommand( GeneralAppNotifications.REQUEST_DATA_RECEIVED, FBHandleRequestCommand);
					facade.registerCommand( GeneralAppNotifications.SOCIAL_LIKE_APP, FBLikeCommand);
					facade.registerCommand( GeneralAppNotifications.SOCIAL_LIKE_APP_CALLBACK, FBLikeCommand);
					facade.registerCommand( GeneralAppNotifications.SOCIAL_ACCEPT_SURPRISE_GIFT, FBLikeCommand);
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