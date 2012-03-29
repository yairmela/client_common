package playtiLib.controller.commands.social.mm
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.controller.commands.social.gift.PublishGiftUserSelectedCommand;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.vo.social.SocialPostVO;
	/**
	 * Gets a SocialPostVO object from notification's body and sends notification (CHOOSE_SN_USER) with the user SN id and registers 
	 * command(CHOOSE_SN_USER_COMPLETE)
	 * in the facade. 
	 */	
	public class MMPublishGiftCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			
			var post_vo:SocialPostVO = notification.getBody() as SocialPostVO;
			
			sendNotification( GeneralAppNotifications.CHOOSE_SN_USER, {additional_data:post_vo, user_sn_id:post_vo.user_sn_id} );
			
			facade.registerCommand( GeneralAppNotifications.CHOOSE_SN_USER_COMPLETE, PublishGiftUserSelectedCommand );
		}
	}
}