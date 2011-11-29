package playtiLib.controller.commands.popup
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.display.GeneralDialogsConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.model.VO.popup.PopupDoActionVO;
	import playtiLib.model.VO.popup.SystemMsgVO;
	import playtiLib.view.components.popups.SystemMsgPopupViewLogic;
	import playtiLib.view.mediators.popups.PopupMediator;
	/**
	 * Class that gets a systemMsgVO object and sends notification to open popup with the msg that it gets.
	 */	
	public class ShowSystemMsgPopupCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			
			var msg_vo:SystemMsgVO = notification.getBody() as SystemMsgVO;
			sendNotification( GeneralAppNotifications.OPEN_POPUP,
				new PopupMediator( msg_vo.popup_name_mc != null ? msg_vo.popup_name_mc: GeneralDialogsConfig.POPUP_SYSTEM_MSG, 
					new SystemMsgPopupViewLogic( msg_vo, msg_vo.popup_name_mc != null ? msg_vo.popup_name_mc : GeneralDialogsConfig.POPUP_SYSTEM_MSG ), 
					new PopupDoActionVO( [msg_vo.is_auto_fixable?GeneralAppNotifications.SERVER_RELOGIN:GeneralAppNotifications.REFRESH_IFRAME],
						[true],
						null,
						msg_vo.is_auto_fixable?null:[GeneralStatistics.REFRESH_IFRAME_AFTER_SYSTEM_MSG]),
					null),
					notification.getType());
		}
	}
}