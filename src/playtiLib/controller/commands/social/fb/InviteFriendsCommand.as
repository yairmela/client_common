package playtiLib.controller.commands.social.fb
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.VO.social.fb.SocialFriendsInfoListVo;
	import playtiLib.model.proxies.social.fb.SendSocialGiftsReqProxy;
	import playtiLib.model.proxies.social.fb.SendSocialInviteReqProxy;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.view.mediators.social.fb.SelectFriendsToInviteMediator;
	
	public class InviteFriendsCommand extends SimpleCommand	{
		
		public static const INVITE_MC:String 			= 'invite_friends_popup';
		public static const MAX_NUMBER_OF_FRIENDS:int 	= 600;
		
		override public function execute( notification:INotification ):void {
			//change the tab to invite tab
			//check if there are more\less then 600 friends
			var dataCapsule_couponValidate:DataCapsule = DataCapsuleFactory.getDataCapsule([/*SocialCallsConfig.FRIENDS_IDS_AND_NAMES*/]);
			dataCapsule_couponValidate.addEventListener( Event.COMPLETE, onDataReady );
			dataCapsule_couponValidate.loadData();
		}
		
		private function onDataReady( event:Event ):void{
			
			var data_capsule:DataCapsule = event.currentTarget as DataCapsule;
			var allFriendsInfo:Array = ( data_capsule.getDataHolderByIndex(0).data as SocialFriendsInfoListVo ).list;
			if( allFriendsInfo.length <= MAX_NUMBER_OF_FRIENDS ){
				if( facade.hasProxy( SendSocialGiftsReqProxy.NAME ) ){
					( facade.retrieveProxy( SendSocialGiftsReqProxy.NAME ) as SendSocialGiftsReqProxy ).onRemove();
				}
				sendNotification( GeneralAppNotifications.CLOSE_POPUP );
				facade.registerMediator( new SelectFriendsToInviteMediator( INVITE_MC ) );
				facade.registerProxy( new SendSocialInviteReqProxy() );
			}else{
				sendNotification( GeneralAppNotifications.FULLSCREEN_MODE, false );
				ExternalInterface.call( 'showFBInviteDialog' );
			}
			ExternalInterface.call('showInviteTab');
		}
	}
}