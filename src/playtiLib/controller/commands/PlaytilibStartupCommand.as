package playtiLib.controller.commands
{
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.content.LocaleContentConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.ServerConfig;
	import playtiLib.config.social.SocialConfig;
	import playtiLib.controller.commands.load.LoadExternalsCommand;
	import playtiLib.controller.commands.popup.SetPauseLoadingPopupCommand;
	import playtiLib.controller.commands.popup.SetPausePopupCommand;
	import playtiLib.controller.commands.popup.SetupPopupsDisplayCommand;
	import playtiLib.controller.commands.popup.ShowSystemMsgPopupCommand;
	import playtiLib.controller.commands.server.RefreshIframeCommand;
	import playtiLib.controller.commands.server.ServerFaultHandlingCommand;
	import playtiLib.controller.commands.server.ServerInitCommand;
	import playtiLib.controller.commands.server.ServerReloginCommand;
	import playtiLib.controller.commands.server.ServerReloginCompleteCommand;
	import playtiLib.controller.commands.server.SystemErrorCommand;
	import playtiLib.controller.commands.social.SocialRegisterCommandsCommand;
	import playtiLib.controller.commands.version.ShowVersionNumberCommand;
	import playtiLib.model.VO.FlashVarsVO;
	import playtiLib.model.VO.amf.request.SessionInfo;
	import playtiLib.model.VO.social.SocialConfigVO;
	import playtiLib.model.proxies.config.AppConfigProxy;
	import playtiLib.model.proxies.config.DisplaySettingsProxy;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.model.proxies.server.AMFServerCallManagerProxy;
	import playtiLib.model.proxies.server.ServerCallManagerProxy;
	import playtiLib.model.proxies.social.JSProxy;
	import playtiLib.utils.network.URLUtil;
	import playtiLib.utils.social.SocialCallManager;
	import playtiLib.utils.tracing.Logger;
	import playtiLib.view.mediators.core.RootMediator;

	/**
	 * This is the basic startup comman class. The startup class of the game that use playtilib should extends this class.
	 * It registers to some important commands and does the initilize of the startup  
	 */
	public class PlaytilibStartupCommand extends SimpleCommand{
		/**
		 * This function is an override function that registers the the flashVars proxy, some general commands
	 	 * and the root mediator 
		 * @param notification
		 * 
		 */		
		override public function execute( notification:INotification ):void {
			
			Logger.log("SocialStartupCommand");
			var main_view:Sprite = notification.getBody() as Sprite;
			
			facade.registerCommand( GeneralAppNotifications.CLOSE, PlaytilibCloseCommand );
			
			//init utils
			URLUtil.init( main_view );
			//set the flash_vars proxy
			facade.registerProxy( new FlashVarsProxy( new FlashVarsVO( main_view.loaderInfo.parameters ) ) );
			//set ServerConfig from flash_vars
			ServerConfig.setPropertiesFromFlashVars( main_view.loaderInfo.parameters, main_view );
			//set local from flash_vars
			LocaleContentConfig.setLanguageFromFlashVars( flash_vars_vo );
			
			//first register all the general social known commands
			facade.registerCommand( GeneralAppNotifications.SOCIAL_REGISTER_COMMANDS, SocialRegisterCommandsCommand );
			//add these general commands registrations
			facade.registerCommand( GeneralAppNotifications.SOCIAL_INSTALL_APPROVED, ServerInitCommand );
			facade.registerCommand( GeneralAppNotifications.LOAD_EXTERNAL_ASSETS, LoadExternalsCommand );
			facade.registerCommand( GeneralAppNotifications.SHOW_VERSION_NUMBER, ShowVersionNumberCommand );
			facade.registerCommand( GeneralAppNotifications.SETUP_POPUPS_DISPLAY, SetupPopupsDisplayCommand );
			facade.registerCommand( GeneralAppNotifications.SET_PAUSE_POPUP, SetPausePopupCommand );
			facade.registerCommand( GeneralAppNotifications.SET_PAUSE_POPUP_WITH_LOADING, SetPauseLoadingPopupCommand );
			facade.registerCommand( GeneralAppNotifications.SERVER_RELOGIN, ServerReloginCommand );
			facade.registerCommand( GeneralAppNotifications.SERVER_RELOGIN_COMPLETE, ServerReloginCompleteCommand );
			facade.registerCommand( GeneralAppNotifications.SYSTEM_ERROR, SystemErrorCommand );
			facade.registerCommand( GeneralAppNotifications.SYSTEM_MSG_POPUP, ShowSystemMsgPopupCommand );
			facade.registerCommand( GeneralAppNotifications.REFRESH_IFRAME, RefreshIframeCommand );
			//init the main view mediator
			facade.registerMediator( new RootMediator( main_view ) );
						
			facade.registerProxy( new DisplaySettingsProxy( main_view.stage ) );
						
			initServerCallManagerProxy();
			
			facade.registerCommand( GeneralAppNotifications.SERVER_FAULT, ServerFaultHandlingCommand);
		}
		
		/**
		 * If the seeion is create outside of the game this function will set it instead of creating new session.
		 * We pass sessionId and not take it from flash_vars_vo because sometimes when we load a module we prefare not to set the session_id in the url to prevent cache breaking
		 * @param sociaConfigVO
		 * 
		 */	
		protected function setExternalSession( sessionId:String ):void {
			var session:SessionInfo = new SessionInfo();
			session.sessionId = sessionId;
			session.userSnId = flash_vars_vo.viewer_id;			
			ServerConfig.session_info = session;
			SocialConfig.viewer_sn_id = flash_vars_vo.viewer_id;
		}
		
		protected function get flash_vars_vo():FlashVarsVO {
			return facade.retrieveProxy( FlashVarsProxy.NAME ).getData() as FlashVarsVO;
		}
		
		/**
		 * Sends notifications(SOCIAL_REGISTER_COMMANDS,SOCIAL_INIT_CONNECTIONS ), inits app proxy for contain socialConfigVo, inits the 
		 * social connections and the socialCallManage
		 * @param sociaConfigVO
		 * 
		 */		
		protected function initiateSocialNetwork( sociaConfigVO:SocialConfigVO ):void {
			//set commands registrations;
			sendNotification( GeneralAppNotifications.SOCIAL_REGISTER_COMMANDS, sociaConfigVO );
			// init app proxy for contain socialConfigVO 			
			facade.registerProxy( new AppConfigProxy( sociaConfigVO ) );
			facade.registerProxy( new ServerCallManagerProxy() );			
			//set iframe listener to apply js changes
			facade.registerProxy( new JSProxy() );
			
			SocialConfig.current_social_network = sociaConfigVO.sn_type;
			
			//init the socail connections
			sendNotification( GeneralAppNotifications.SOCIAL_INIT_CONNECTIONS, sociaConfigVO );
			
			// init socialCallmanager
			SocialCallManager.init( SocialConfig.current_social_network );
		}
		/**
		 * Sends notidication to load external assets (LOAD_EXTERNAL_ASSETS)
		 * @param initialAssetsLoadConfigPath
		 * 
		 */		
		protected function loadExternals( initialAssetsLoadConfigPath:String ):void {
			//execute LoadExternalsCommand
			sendNotification( GeneralAppNotifications.LOAD_EXTERNAL_ASSETS, initialAssetsLoadConfigPath );
		}
			
		/**
		 * Sends notification that set social banners 
		 * @param game_banners_id
		 * 
		 */		
		protected function initSocialBanners( game_banners_id:int ):void {
			//set social banners
			sendNotification( GeneralAppNotifications.SET_SOCIAL_BANNERS, game_banners_id )
		}
		
		protected function setupPopupsDisplay( centerToWidth : uint, centerToHeight : uint ):void {
			//setup popups display params
			sendNotification( GeneralAppNotifications.SETUP_POPUPS_DISPLAY, {width: centerToWidth, height: centerToHeight} )
		}
		
		protected function initServerCallManagerProxy():void {
			
			facade.registerProxy( new AMFServerCallManagerProxy() );
		}
	}
}