package playtiLib.controller.commands.social.vk
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.vk.VKGeneralDialogs;
	import playtiLib.config.social.vk.VKNotifications;
	import playtiLib.controller.commands.popup.OpenPopupCommand;
	import playtiLib.model.VO.popup.PopupDoActionVO;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.utils.social.vk.VkWrapperUtil;
	import playtiLib.utils.tracing.Logger;
	import playtiLib.view.components.popups.PopupViewLogic;
	import playtiLib.view.mediators.popups.PopupMediator;
	
	public class VKSettingsCheckCommand extends SimpleCommand
	{
		private static const required_params:Array = [VkWrapperUtil.PERMISSIONS_FRIENDS, VkWrapperUtil.PERMISSIONS_NOTIFICATIONS];
		
		override public function execute(notification:INotification):void {
			var settings_id:int = notification.getBody() as int;
			
			//check vk setting. 
			if(VkWrapperUtil.getInstance().analizeSettingNumber( settings_id, required_params)) {
				// finish install process
				sendNotification( GeneralAppNotifications.SOCIAL_INSTALL_APPROVED );
			} else  {
				//show  settings box 
				VkWrapperUtil.getInstance().addEventListener(VkWrapperUtil.EVENT_onWindowBlur, onWindowBlur);
				VkWrapperUtil.getInstance().addEventListener(VkWrapperUtil.EVENT_onSettingsChanged, onSettingsChange);
				VkWrapperUtil.getInstance().showSettingsBox(required_params);
			}	
		}
		
		private function onWindowBlur(event:Event):void {
			VkWrapperUtil.getInstance().removeEventListener(VkWrapperUtil.EVENT_onWindowBlur, onWindowBlur);
			VkWrapperUtil.getInstance().addEventListener(VkWrapperUtil.EVENT_onWindowFocus, onSettingsCancelChange);
		}
		
		private function onSettingsChange(event:EventTrans):void
		{
			Logger.log('VKSettingsCheckCommand - onSettingsChange');
			VkWrapperUtil.getInstance().removeEventListener(VkWrapperUtil.EVENT_onWindowFocus, onSettingsCancelChange);
			VkWrapperUtil.getInstance().removeEventListener(VkWrapperUtil.EVENT_onSettingsChanged, onSettingsChange);
			
			if(VkWrapperUtil.getInstance().analizeSettingNumber( event.data[0] as int, required_params)) {
				// finish install process
				sendNotification( GeneralAppNotifications.SOCIAL_INSTALL_APPROVED );
			} else  {
				onSettingsCancelChange( null );
			}
		}
		
		private function onSettingsCancelChange(event:Event):void {
			Logger.log('VKSettingsCheckCommand - onSettingsCancelChange');
			//first remove listenres (inorder to avoid more than one listener in the future)
			VkWrapperUtil.getInstance().removeEventListener(VkWrapperUtil.EVENT_onWindowFocus, onSettingsCancelChange);
			VkWrapperUtil.getInstance().removeEventListener(VkWrapperUtil.EVENT_onSettingsChanged, onSettingsChange);
			
			sendNotification( GeneralAppNotifications.OPEN_POPUP,
				new PopupMediator( VKGeneralDialogs.POPUP_CHANGE_SETTINGS, 
					new PopupViewLogic( VKGeneralDialogs.POPUP_CHANGE_SETTINGS ),
					new PopupDoActionVO( [GeneralAppNotifications.SETTINGS_CHECK], [0] )
				),
				OpenPopupCommand.FORCE_OPEN );
		}
		
		private function notInstalled( ):void {
			sendNotification( GeneralAppNotifications.SOCIAL_GAME_NOT_INSTALLED );
		}
	}
}