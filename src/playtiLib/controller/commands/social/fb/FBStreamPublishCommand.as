package playtiLib.controller.commands.social.fb
{
	import flash.external.ExternalInterface;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.vo.social.SocialPostVO;
	import playtiLib.model.proxies.config.DisplaySettingsProxy;
	import playtiLib.utils.social.fb.FBSocialCallManager;
	/**
	 * Gets a SocialPostVO object by the notification's body and by it's information (moviename, user_msg, title, description, img_path, user_promt_msg ), 
	 * it makes an external interface call for publishing stream. It also sends notification (SET_PAUSE_POPUP) and sets the fullscreen setting to false.
	 * @see flash.external.ExternalInterface
	 * @see playtiLib.utils.social.fb.FBSocialCallManager
	 * @see playtiLib.model.vo.social.SocialPostVO
	 */
	public class FBStreamPublishCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			
			var post_data:SocialPostVO = notification.getBody() as SocialPostVO;
			//moviename, user_msg, title, description, img_path, user_promt_msg
			ExternalInterface.call( 'streamPublish',
									FBSocialCallManager.swf_object_name,
									post_data.user_msg,
									post_data.title,
									post_data.descreiption,
									post_data.image_path,
									post_data.user_promt_msg,
									post_data.event_type,
									post_data.token );

			sendNotification( GeneralAppNotifications.SET_PAUSE_POPUP, true );
			//TODO:uncomment after fullscreen functionality will be integrated
			( facade.retrieveProxy( DisplaySettingsProxy.NAME ) as DisplaySettingsProxy ).fullscreen = false;
		}
	}
}