package playtiLib.controller.commands.social.vk
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.utils.social.vk.VkWrapperUtil;
	import playtiLib.utils.statistics.Tracker;
	import playtiLib.utils.tracing.Logger;
	
	public class VKInviteFriendsCommand extends SimpleCommand implements ICommand
	{
		override public function execute( notification:INotification ):void {
			sendNotification(GeneralAppNotifications.FULLSCREEN_MODE,false);
			Logger.log("VKInviteFriendsCommand");
			VkWrapperUtil.getInstance().showInviteBox();
			//TODO: check why this is not a part of all invite commands ( for example I can't see it in FBInviteFriendsCommand
			sendNotification( GeneralAppNotifications.TRACK, null, GeneralStatistics.OPEN_INVITE_FRIENDS_DIALOG );
		}
	}
}