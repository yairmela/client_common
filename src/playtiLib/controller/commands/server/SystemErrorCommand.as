package playtiLib.controller.commands.server {
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.ServerErrorsConfig;
	import playtiLib.config.server.SystemErrorConfig;
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.model.vo.popup.SystemMsgVO;
	import playtiLib.utils.locale.TextLib;
	
	/**
	 * Handles the system erors config. It gets the error code by the notification's body, make a new msg, sends notification(SYSTEM_MSG_POPUP)
	 * and tracks the action.
	 * @see playtiLib.model.vo.popup.SystemMsgVO
	 */
	public class SystemErrorCommand extends SimpleCommand {
		
		override public function execute(notification:INotification):void {
			var error_code:int = notification.getBody() as int;
			switch (error_code){
				case SystemErrorConfig.ERROR_GET_XML_CONTENT: 
				case SystemErrorConfig.ERROR_GET_SWF_CONTENT: 
				case SystemErrorConfig.ERROR_GET_CONTENT: 
				case SystemErrorConfig.ERROR_RELOGIN: 
				case SystemErrorConfig.ERROR_IOERROR:				
				case SystemErrorConfig.ERROR_SERVER_SOME_ERROR: 
				case SystemErrorConfig.ERROR_SERVER_SESSION_EXPIRE: 
				case SystemErrorConfig.ERROR_SERVER_USER_NOT_FOUND: 
					sendNotification(GeneralAppNotifications.TRACK, {error_code: error_code}, GeneralStatistics.ERROR_SYSTEM);
					showServerConnection();
					break;
				case SystemErrorConfig.LOGIN_NOT_ALLOWED_AT_THIS_MOMENT: 
					showLoginNotAllowed();
					break;
				case ServerErrorsConfig.ERROR_SERVER_USER_HAS_FEW_SESSION:
					showSimultaneouslySessionProblem();
					break;
				case ServerErrorsConfig.ERROR_SERVER_SESSION_IS_INVALID: 
					showSessionProblem();
					break;
				case ServerErrorsConfig.ERROR_COUPONS_MAINTENANCE:
					sendNotification( GeneralAppNotifications.COUPON_SYSTEM_UNAVAILABLE );
					break;
				case ServerErrorsConfig.ERROR_SERVER_MAINTENANCE: 
				case ServerErrorsConfig.ERROR_PLUGIN_MAINTENANCE: 
				case ServerErrorsConfig.ERROR_MISSIONS_MAINTENANCE: 
					showMaintenance(error_code);
					break;
			}
		}
		
		/**
		 * Fills in SystemMsgVO var all the information about the server and sends the vars with an appropriate notification.
		 *
		 */
		private function showLoginNotAllowed():void {
			showSystemMsgPopup('system.login_not_allowed.title', 'system.login_not_allowed.description', true, false );
		}
		
		private function showServerConnection():void {
			showSystemMsgPopup('system.connection_lost.title', 'system.connection_lost.description', true, false );
		}
		
		private function showSessionProblem():void {
			showSystemMsgPopup('system.session_problem.title', 'system.session_problem.description', true, false, true );
		}
		
		private function showSimultaneouslySessionProblem():void {			
			showSystemMsgPopup('system.simultaneously_session_problem.title', 'system.simultaneously_session_problem.description', true, false, true );
		}		
		
		private function showMaintenance(error_code:int):void {
			var type:String
			switch (error_code){
				case ServerErrorsConfig.ERROR_SERVER_MAINTENANCE: 
					type = "server_maintenance";
					break;
				case ServerErrorsConfig.ERROR_COUPONS_MAINTENANCE: 
					type = "coupons_maintenance";
					break;
				case ServerErrorsConfig.ERROR_PLUGIN_MAINTENANCE: 
					type = "plugin_maintenance";
					break;
				case ServerErrorsConfig.ERROR_MISSIONS_MAINTENANCE: 
					type = "missions_maintenance";
					break;
			}
			
			showSystemMsgPopup('system.' + type + '.title', 'system.' + type + '.description', false, false );
		}
		
		private function showSystemMsgPopup(title:String, description:String, hasRefreshBtn:Boolean, hasCloseBtn:Boolean, isAutoFixable:Boolean = false):void {
			var sys_msg:SystemMsgVO = new SystemMsgVO();
			sys_msg.title = TextLib.lib.retrive(title);
			sys_msg.description = (TextLib.lib.retrive(description) as String).replace("[n]", String.fromCharCode(13));
			sys_msg.description = sys_msg.description.replace("[n]", String.fromCharCode(13));
			sys_msg.is_refresh_btn_needed = hasRefreshBtn;
			sys_msg.has_close_btn = hasCloseBtn;			
			sys_msg.is_auto_fixable = isAutoFixable;
			sendNotification(GeneralAppNotifications.SYSTEM_MSG_POPUP, sys_msg);
		}
	}
}