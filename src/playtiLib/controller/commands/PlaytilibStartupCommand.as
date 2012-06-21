package playtiLib.controller.commands
{
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.config.content.LocaleContentConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.ServerConfig;
	import playtiLib.config.social.SocialConfig;
	import playtiLib.controller.commands.load.LoadExternalsCommand;
	import playtiLib.controller.commands.popup.*;
	import playtiLib.controller.commands.server.*;
	import playtiLib.controller.commands.social.SocialRegisterCommandsCommand;
	import playtiLib.controller.commands.social.fb.FBPostActionCommand;
	import playtiLib.controller.commands.ui.SetupUIDisplayCommand;
	import playtiLib.controller.commands.version.ShowVersionNumberCommand;
	import playtiLib.model.proxies.config.AppConfigProxy;
	import playtiLib.model.proxies.config.DisplaySettingsProxy;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.model.proxies.server.AMFServerCallManagerProxy;
	import playtiLib.model.proxies.server.ServerCallManagerProxy;
	import playtiLib.model.proxies.social.JSProxy;
	import playtiLib.model.proxies.user.DeviceGUIDProxy;
	import playtiLib.model.vo.FlashVarsVO;
	import playtiLib.model.vo.amf.request.SessionInfo;
	import playtiLib.model.vo.social.SocialConfigVO;
	import playtiLib.utils.network.URLUtil;
	import playtiLib.utils.social.SocialCallManager;
	import playtiLib.utils.statistics.Tracker;
	import playtiLib.utils.statistics.googleAnalytics.GeneralGoogleAnalyticsTracker;
	import playtiLib.utils.tracing.Logger;
	import playtiLib.view.mediators.core.RootMediator;

	public class PlaytilibStartupCommand extends SimpleCommand{

		override public function execute( notification:INotification ):void 
		{
			Logger.log("SocialStartupCommand");
			var main_view:Sprite = notification.getBody() as Sprite;
			
			facade.registerCommand( GeneralAppNotifications.CLOSE, PlaytilibCloseCommand );
			
			URLUtil.init( main_view );
			facade.registerProxy( new FlashVarsProxy( new FlashVarsVO( main_view.loaderInfo.parameters ) ) );
			ServerConfig.setPropertiesFromFlashVars( main_view.loaderInfo.parameters, main_view );
			LocaleContentConfig.setLanguageFromFlashVars( flashVars );
			
			facade.registerCommand( GeneralAppNotifications.SOCIAL_REGISTER_COMMANDS, SocialRegisterCommandsCommand );

			facade.registerCommand( GeneralAppNotifications.SOCIAL_INSTALL_APPROVED, ServerInitCommand );
			facade.registerCommand( GeneralAppNotifications.LOAD_EXTERNAL_ASSETS, LoadExternalsCommand );
			facade.registerCommand( GeneralAppNotifications.SHOW_VERSION_NUMBER, ShowVersionNumberCommand );
			facade.registerCommand( GeneralAppNotifications.SETUP_UI_DISPLAY, SetupUIDisplayCommand );
			facade.registerCommand( GeneralAppNotifications.SET_PAUSE_POPUP, SetPausePopupCommand );
			facade.registerCommand( GeneralAppNotifications.SET_PAUSE_POPUP_WITH_LOADING, SetPauseLoadingPopupCommand );
			facade.registerCommand( GeneralAppNotifications.SERVER_RELOGIN, ServerReloginCommand );
			facade.registerCommand( GeneralAppNotifications.SERVER_RELOGIN_COMPLETE, ServerReloginCompleteCommand );
			facade.registerCommand( GeneralAppNotifications.SYSTEM_ERROR, SystemErrorCommand );
			facade.registerCommand( GeneralAppNotifications.SYSTEM_MSG_POPUP, ShowSystemMsgPopupCommand );
			facade.registerCommand( GeneralAppNotifications.REFRESH_IFRAME, RefreshIframeCommand );
			
			facade.registerCommand( GeneralAppNotifications.POST_SOCIAL_ACTION, FBPostActionCommand );

			facade.registerMediator( new RootMediator( main_view ) );
						
			facade.registerProxy( new DisplaySettingsProxy( main_view.stage ) );
			
			facade.registerProxy( new AMFServerCallManagerProxy() );
			
			facade.registerCommand( GeneralAppNotifications.SERVER_FAULT, ServerFaultHandlingCommand);
						
			initSessionInfo();
		}

		private function initSessionInfo():void
		{
			var deviceGUIDProxy : DeviceGUIDProxy = new DeviceGUIDProxy( flashVars.viewer_id );
			facade.registerProxy(deviceGUIDProxy);
			
			var sessionInfo : SessionInfo = ServerConfig.sessionInfo;
			sessionInfo.guid = deviceGUIDProxy.GUID;
			
			ServerConfig.sessionInfo = sessionInfo;
		}
		
		protected function get flashVars():FlashVarsVO 
		{
			return facade.retrieveProxy( FlashVarsProxy.NAME ).getData() as FlashVarsVO;
		}
		
		protected function initiateSocialNetwork( sociaConfigVO:SocialConfigVO ):void 
		{
			sendNotification( GeneralAppNotifications.SOCIAL_REGISTER_COMMANDS, sociaConfigVO );
			facade.registerProxy( new AppConfigProxy( sociaConfigVO ) );
			facade.registerProxy( new ServerCallManagerProxy() );
			
			createJSProxy();
			
			SocialConfig.current_social_network = sociaConfigVO.sn_type;
			sendNotification( GeneralAppNotifications.SOCIAL_INIT_CONNECTIONS, sociaConfigVO );

			SocialCallManager.init( SocialConfig.current_social_network );
		}

		protected function loadExternals( initialAssetsLoadConfigPath:String ):void 
		{
			sendNotification( GeneralAppNotifications.LOAD_EXTERNAL_ASSETS, initialAssetsLoadConfigPath );
		}
		
		protected function initGATracker( tracker : GeneralGoogleAnalyticsTracker, root : Sprite, account : String, is_debug : Boolean = false ):void 
		{
			tracker.init( root, account, 'AS3', is_debug );
			Tracker.setTracker(tracker, GeneralGoogleAnalyticsTracker.NAME);
		}
			
		protected function initSocialBanners( game_banners_id:int ):void {
			//set social banners
			sendNotification( GeneralAppNotifications.SET_SOCIAL_BANNERS, game_banners_id )
		}
		
		protected function setupUIDisplay( centerToWidth : uint, centerToHeight : uint ):void {
			//setup ui display params
			sendNotification( GeneralAppNotifications.SETUP_UI_DISPLAY, {width: centerToWidth, height: centerToHeight} )
		}
		
		protected function createJSProxy() : void {
			
			facade.registerProxy( new JSProxy() );
		}
	}
}