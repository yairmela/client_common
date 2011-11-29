package playtiLib.controller.commands.social.mm
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.VO.social.SocialPostVO;
	import playtiLib.model.proxies.user.UserProxy;
	import playtiLib.utils.social.mm.MailruCall;
	import playtiLib.utils.social.mm.MailruCallEvent;
	/**
	 * Gets a SocialPostVO object, retrieves the user proxy and checks if the user SN id that in SocialPostVo is  the same id
	 * like the user id that in the user proxy. If it isn't equal, it adds listener to MailruCall (GUESTBOOK_PUBLISH) and executes gustbook 
	 * post by the MailruCall. If it is equal, it adds listener (STREAM_PUBLISH) and executes stream post by the MailreCall. 
	 */	
	public class MMPublishToWallCommand extends SimpleCommand	{
		
		private var post_image_url_path:String;
		private var post_data:SocialPostVO;
		
		override public function execute( notification:INotification ):void	{
			
			post_data = notification.getBody() as SocialPostVO;
			
			var user_proxy:UserProxy = facade.retrieveProxy( UserProxy.NAME ) as UserProxy;
			if (post_data.user_sn_id != user_proxy.userSocialInfo.sn_id) {
				MailruCall.addEventListener( MailruCallEvent.GUESTBOOK_PUBLISH, onGuestBookPostSaveCompleted );
				MailruCall.exec ( 'mailru.common.guestbook.post', null, 
					{
						'title': post_data.title,
						'text': post_data.descreiption,
						'img_url':post_data.image_path,
						'uid': post_data.user_sn_id
					} );
			}else{
				MailruCall.addEventListener( MailruCallEvent.STREAM_PUBLISH, onWallPostSaveCompleted );
				MailruCall.exec ( 'mailru.common.stream.post', null, 
					{
						'title': post_data.title,
						'text': post_data.descreiption,
						'img_url':post_data.image_path
					} );
			}
			
		}
		/**
		 * Gets an object and checks if the status in it's data property = 'opened', it removes the listener from the MailreCall
		 * (STREAM_PUBLISH) and executes the  onPublishComplete function.  
		 * @param response
		 * 
		 */		
		private function onWallPostSaveCompleted( response:Object ):void	{
			
			if ( response.data.status != "opened" ){
				MailruCall.removeEventListener( MailruCallEvent.STREAM_PUBLISH, onWallPostSaveCompleted );
				onPublishComplete( response );
			}
		}
		/**
		 * Gets an object that checks if the status in the it's data property =  'publishSuccess', it sends notification 
		 * (PUBLISH_TO_WALL_APPROVED) and if not, it sends notification (PUBLISH_TO_WALL_COMPLETE)
		 * @param response
		 * 
		 */		
		private function onPublishComplete( response:Object ):void{
			
			if ( response.data.status == "publishSuccess" )		
				sendNotification( GeneralAppNotifications.PUBLISH_TO_WALL_APPROVED, post_data );
			else
				sendNotification( GeneralAppNotifications.PUBLISH_TO_WALL_COMPLETE, false );
		}
		/**
		 * Gets an object and checks if its status in it's data property is 'opened'. If not, it removes the listener from
		 * MailruCall (GUESTBOOK_PUBLISH) and executes the function onPublishComplete.
		 * @param response
		 * 
		 */		
		private function onGuestBookPostSaveCompleted( response:Object ):void	{
			
			if ( response.data.status != "opened" ){
				MailruCall.removeEventListener( MailruCallEvent.GUESTBOOK_PUBLISH, onGuestBookPostSaveCompleted );
				onPublishComplete( response );
			}
		}
	}
}