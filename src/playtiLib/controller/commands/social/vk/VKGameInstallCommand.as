package playtiLib.controller.commands.social.vk
{
	import flash.events.Event;
		
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.vk.VKGeneralDialogs;
	import playtiLib.config.social.vk.VKNotifications;
	import playtiLib.controller.commands.popup.OpenPopupCommand;
	import playtiLib.model.VO.FlashVarsVO;
	import playtiLib.model.VO.popup.PopupDoActionVO;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.utils.social.vk.VkWrapperUtil;
	import playtiLib.utils.tracing.Logger;
	import playtiLib.view.components.popups.PopupViewLogic;
	import playtiLib.view.mediators.popups.PopupMediator;
	
	public class VKGameInstallCommand extends SimpleCommand
	{
		override public function execute(notification:INotification) : void {
			Logger.log('VKGameInstallCommand');
			
			var flash_vars:FlashVarsVO = (facade.retrieveProxy(FlashVarsProxy.NAME) as FlashVarsProxy).flash_vars;
			
			Logger.log("checkIsAdded is_app_user = "+flash_vars.is_app_user);
			
			if(flash_vars.is_app_user)
				sendNotification( GeneralAppNotifications.SETTINGS_CHECK, flash_vars.api_settings);
			else 
			{
				VkWrapperUtil.getInstance().addEventListener(VkWrapperUtil.EVENT_onApplicationAdded, onAppAdded);
				VkWrapperUtil.getInstance().addEventListener(VkWrapperUtil.EVENT_onWindowFocus, onAppNotAdded);
				VkWrapperUtil.getInstance().showInstallBox();	
			}
		}
		
		private function onAppAdded(event:Event):void
		{
			Logger.log('VKGameInstallCommand - onAppAdded');
			//first remove listenres
			VkWrapperUtil.getInstance().removeEventListener(VkWrapperUtil.EVENT_onWindowFocus, onAppNotAdded);
			VkWrapperUtil.getInstance().removeEventListener(VkWrapperUtil.EVENT_onApplicationAdded, onAppAdded);
			sendNotification( GeneralAppNotifications.SETTINGS_CHECK, 0 );
		}
		
		private function onAppNotAdded(event:Event):void {
			Logger.log('VKGameInstallCommand - onAppNotAdded');
			//first remove listenres (inorder to avoid more than one listener in the future)
			VkWrapperUtil.getInstance().removeEventListener(VkWrapperUtil.EVENT_onWindowFocus, onAppNotAdded);
			VkWrapperUtil.getInstance().removeEventListener(VkWrapperUtil.EVENT_onApplicationAdded, onAppAdded);
			sendNotification( GeneralAppNotifications.OPEN_POPUP,
				new PopupMediator( VKGeneralDialogs.POPUP_ADD_APP, 
					new PopupViewLogic( VKGeneralDialogs.POPUP_ADD_APP),
					new PopupDoActionVO( [GeneralAppNotifications.SOCIAL_GAME_INSTALL_CHECK] )
				),
				OpenPopupCommand.FORCE_OPEN );
		}
	}
}