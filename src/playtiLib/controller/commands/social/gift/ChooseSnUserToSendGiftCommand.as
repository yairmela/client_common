package playtiLib.controller.commands.social.gift
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.GeneralCallsConfig;
	import playtiLib.controller.commands.popup.OpenPopupCommand;
	import playtiLib.model.proxies.user.ChooseSnUserProxy;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.utils.data.DataServerResponseVO;
	import playtiLib.view.mediators.popups.ChooseSnUserPopupMediator;
	/**
	 * Gets process data object by the notification's body, gets data capsule from the DataCapsuleFactory and loads the data from server(PREPARE_GIFT). 
	 * When the data is ready, it sends notification for force open popup (ChooseSnUserPopupMediator) and registers new SN user proxy.
	 * function.
	 * 
	 */	
	public class ChooseSnUserToSendGiftCommand extends SimpleCommand	{
		
		private var process_data:Object;
		
		override public function execute( notification:INotification ):void {
			
			process_data = notification.getBody();
			
			var exclude_friends_data_capsule:DataCapsule = DataCapsuleFactory.getDataCapsule( [GeneralCallsConfig.PREPARE_GIFT] );
			exclude_friends_data_capsule.addEventListener( Event.COMPLETE, onExcludeFriendsLoaded );
			exclude_friends_data_capsule.loadData();
		}
		/**
		 * Gets dataCapsule object and sets the process_data's variable infomation. It sends notification to force open popup 
		 * with the user id and the additional data that it got and registers a new SN user proxy.
		 * @param event
		 * 
		 */		
		private function onExcludeFriendsLoaded( event:Event ):void {
			
			var response:DataServerResponseVO = ( event.target as DataCapsule ).getDataHolderByIndex(0).server_response as DataServerResponseVO;		
			process_data.additional_data.token = response.response_json.result.gift_token;
			
			sendNotification( GeneralAppNotifications.OPEN_POPUP,
				new ChooseSnUserPopupMediator( process_data.user_sn_id, process_data.additional_data ), OpenPopupCommand.FORCE_OPEN );
			
			facade.registerProxy( new ChooseSnUserProxy( (response.response_json.result.gift_receivers as String).split(',') ) );
		}
	}
}