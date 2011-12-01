package playtiLib.controller.commands.social.fb 
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.utils.data.DataCallConfig;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.config.social.SocialCallsConfig;

	public class FBAcceptSurpriseGift extends SimpleCommand 
	{
		
		override public function execute( notification:INotification ):void {
			
			sendNotification( GeneralAppNotifications.FULLSCREEN_MODE,false );
		
			var callConfig:DataCallConfig = AMFGeneralCallsConfig.ACCEPT_SURPRISE_GIFT;
			
			var capsule:DataCapsule = DataCapsuleFactory.getDataCapsule([callConfig]);
			capsule.addEventListener( Event.COMPLETE, onGiftDataReady );
			capsule.loadData();
		}
		
		private function onLikeDataReady( event:Event ):void{			
			var giftDataHolder:Object = ( event.target as DataCapsule ).getDataHolderByIndex(0).data;
			ExternalInterface.call( 'setSurpriseGiftStatus', giftDataHolder );
		}
		
	}

}