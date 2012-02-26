package playtiLib.controller.commands.social.fb
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.display.GeneralDialogsConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.model.proxies.social.fb.SendSocialInviteReqProxy;
	import playtiLib.model.vo.social.fb.SocialFriendsInfoListVo;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.view.mediators.social.fb.SelectFriendsToInviteMediator;
	
	public class InviteFriendsCommand extends SimpleCommand	{
		
		public static const MAX_NUMBER_OF_FRIENDS:int 	= 700;
		
		override public function execute( notification:INotification ):void {
			//change the tab to invite tab
			//check if there are more\less then 600 friends
			var dataCapsule:DataCapsule = DataCapsuleFactory.getDataCapsule([SocialCallsConfig.FRIENDS_IDS_AND_NAMES]);
			dataCapsule.addEventListener( Event.COMPLETE, onDataReady );
			dataCapsule.loadData();
		}
		
		private function onDataReady( event:Event ):void{
			
			var data_capsule:DataCapsule = event.currentTarget as DataCapsule;
			var allFriendsInfo:Array = ( data_capsule.getDataHolderByIndex(0).data as SocialFriendsInfoListVo ).list;
			if( allFriendsInfo.length <= MAX_NUMBER_OF_FRIENDS ){
				openFlashPopup();
			}else{
				openFacebookPopup();
			}
			ExternalInterface.call('showInviteTab');
		}
		
		private function openFacebookPopup():void
		{
			sendNotification( GeneralAppNotifications.FULLSCREEN_MODE, false );
			ExternalInterface.call( 'showFBInviteDialog' );
		}
		
		private function openFlashPopup():void
		{
			sendNotification( GeneralAppNotifications.CLOSE_POPUP );
			facade.registerMediator( new SelectFriendsToInviteMediator( GeneralDialogsConfig.POPUP_INVITE_FRIENDS ) );
			facade.registerProxy( new SendSocialInviteReqProxy() );
		}
	}
}