package playtiLib.controller.commands.load
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.ServerConfig;
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.controller.commands.popup.OpenPopupCommand;
	import playtiLib.model.proxies.config.ArenasProxy;
	import playtiLib.model.proxies.config.HelpProxy;
	import playtiLib.model.proxies.config.HostProxy;
	import playtiLib.model.proxies.config.VersionProxy;
	import playtiLib.model.proxies.data.XMLProxy;
	import playtiLib.model.proxies.load.LoadConfigProxy;
	import playtiLib.utils.load.MultiLoadManager;
	import playtiLib.utils.locale.TextLib;
	import playtiLib.utils.network.URLUtil;
	import playtiLib.utils.sounds.SoundsLib;
	import playtiLib.utils.tracing.Logger;
	import playtiLib.utils.warehouse.GraphicsWarehouseList;
	import playtiLib.utils.warehouse.SWFGraphicsWarehouse;
	import playtiLib.view.components.popups.InitialLoadErrorViewPopup;
	import playtiLib.view.components.popups.PopupViewLogic;
	import playtiLib.view.mediators.popups.PopupMediator;
	import playtiLib.view.mediators.preload.MainPreloaderMediator;

	public class LoadExternalsCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void 
		{
			var load_config_path:String = notification.getBody() as String;

			if( !URLUtil.isRunnedLocaly() )
				load_config_path += "?nocache=" + Math.random(); 
			
			facade.registerMediator( new MainPreloaderMediator() );
			
			var xml_loader:URLLoader = new URLLoader();
			
			xml_loader.addEventListener( Event.COMPLETE, xmlLoadComplete );
			xml_loader.addEventListener( IOErrorEvent.IO_ERROR,  trace );
			xml_loader.load( new URLRequest( load_config_path ) );
			
			sendNotification( GeneralAppNotifications.TRACK, null, GeneralStatistics.INITIAL_ASSETS_LOAD_START );
		}
	
		protected function xmlLoadComplete( event:Event ):void 
		{
			Logger.log( "load_xml_config ready" );
			var load_config:XML = new XML( event.target.data );
			facade.registerProxy( new LoadConfigProxy( LoadConfigProxy.NAME, null, load_config ) );
			loadCustomPreloadResource( load_config );
			loadMainResource( load_config );
		}

		protected function loadCustomPreloadResource( load_config:XML ):void 
		{
			var preloader_m_loader:MultiLoadManager = new MultiLoadManager;
			preloader_m_loader.addEventListener( ProgressEvent.PROGRESS, preloadingAssetsProgressHandler );
			preloader_m_loader.addEventListener( Event.COMPLETE, preloadingAssetsCompleteHandler );
			preloader_m_loader.addEventListener( IOErrorEvent.IO_ERROR, trace );

			var graphic_library:SWFGraphicsWarehouse;
			for each( var library:XML in load_config.resources.preload.libraries.library ) 
			{
				graphic_library = new SWFGraphicsWarehouse();
				GraphicsWarehouseList.addNewWarehouse( graphic_library );
				preloader_m_loader.addLoadingProcess( graphic_library, SWFGraphicsWarehouse, Event.COMPLETE );
				graphic_library.load( ServerConfig.ASSETS_SERVER_IP + library.@url );
			}
		}

		/**
		 * Loads the main preloader resources parallely. It inits multiLoader and registers to its events (progress, complete and errors).
		 * It goes over the xml files and brings xmls(can be strings, sounds, hosts, helps, version and graphic), registers them and loads the 
		 * assets. It done by TextLib(string), SoundsLib(sound), HostProxy(host), HelpProxy(help), VersionProxy(version) and by GraphicsWarehouseList(grafics).
		 * @param load_config
		 * 
		 */		
		protected function loadMainResource( load_config:XML ):void {
			//load gamelobby resources parallely
			//init multiLoader and register to its events
			var game_lobby_m_loader:MultiLoadManager = new MultiLoadManager();
			game_lobby_m_loader.addEventListener( ProgressEvent.PROGRESS, gamelobbyAssetsProgressHandler );
			game_lobby_m_loader.addEventListener( Event.COMPLETE, gamelobbyAssetsCompleteHandler );
			game_lobby_m_loader.addEventListener(IOErrorEvent.IO_ERROR,  trace );
			//go over all the game lobby xml files register them and load them
			var xml_proxy:XMLProxy;
			for each( var xml_node:XML in load_config.resources.main.xmls.xml ) {
				switch( xml_node.@name.toString() ) {
					case 'strings':
						var xml_lodaer:URLLoader = TextLib.loadStringsXML( ServerConfig.ASSETS_SERVER_IP + xml_node.@url );
						game_lobby_m_loader.addLoadingProcess( xml_lodaer, URLLoader, Event.COMPLETE );
						break;
					case 'sounds':
						//start load sounds process ( sounds will load one after the other )
						SoundsLib.lib.loadSoundsByXML( ServerConfig.ASSETS_SERVER_IP + xml_node.@url );
						break;
					case 'host':
						xml_proxy = new HostProxy( ServerConfig.ASSETS_SERVER_IP + xml_node.@url );
						break;
					case 'help':
						xml_proxy = new HelpProxy( ServerConfig.ASSETS_SERVER_IP + xml_node.@url );
						break;
					case 'version':
						xml_proxy = new VersionProxy( ServerConfig.ASSETS_SERVER_IP + xml_node.@url );
						break;
					case 'arenas':
						xml_proxy = new ArenasProxy(ServerConfig.ASSETS_SERVER_IP + xml_node.@url);
						break;					
				}
				
				if( xml_proxy ) {
					facade.registerProxy( xml_proxy )
					game_lobby_m_loader.addLoadingProcess( xml_proxy, URLLoader, Event.COMPLETE );
					xml_proxy = null;
				}
			}
			
			var graphic_library:SWFGraphicsWarehouse;
			//go over all the gamelobby libraries register them and initiate thier loading.
			for each( var library:XML in load_config.resources.main.libraries.library ) {
				if(library.@name == 'sounds') {
					SoundsLib.lib.loadSoundsWarehouse( ServerConfig.ASSETS_SERVER_IP + library.@url );
				} else {
					graphic_library = new SWFGraphicsWarehouse();
					graphic_library.addEventListener( IOErrorEvent.IO_ERROR, criticalAssetIOError );
					GraphicsWarehouseList.addNewWarehouse( graphic_library );
					game_lobby_m_loader.addLoadingProcess( graphic_library, SWFGraphicsWarehouse, Event.COMPLETE );
	
					var current_url:String = ServerConfig.ASSETS_SERVER_IP + library.@url;
					graphic_library.load( current_url );
				}
			}
		}
		/**
		 * Sends notification (LOAD_CUSTOM_PRELOADER_PROGRESS) when there is event (PROGRESS) on custom preloader manager 
		 * @param event
		 * 
		 */		
		protected function preloadingAssetsProgressHandler( event:Event ):void {
			
			sendNotification( GeneralAppNotifications.LOAD_CUSTOM_PRELOADER_PROGRESS, event );
		}
		/**
		 * Tracks INITIAL_ASSETS_PRELOADER_READY and sends notification LOAD_CUSTOM_PRELOADER_COMPLETE. The function called when
		 * there is event (COMPLETE) on the custom preloader manager.
		 * @param event
		 * 
		 */		
		protected function preloadingAssetsCompleteHandler( event:Event ):void {
			
			sendNotification( GeneralAppNotifications.TRACK, null, GeneralStatistics.INITIAL_ASSETS_PRELOADER_READY );
			sendNotification( GeneralAppNotifications.LOAD_CUSTOM_PRELOADER_COMPLETE );
		}
		/**
		 * Sends notification LOAD_INITIAL_ASSETS_PROGRESS when there is event (PROGRESS) on main preloader manager. 
		 * @param event
		 * 
		 */		
		protected function gamelobbyAssetsProgressHandler( event:Event ):void {
			
			sendNotification( GeneralAppNotifications.LOAD_INITIAL_ASSETS_PROGRESS, event );
		}

		protected function criticalAssetIOError( event:Event ):void
		{
			sendNotification( GeneralAppNotifications.OPEN_POPUP,
				new PopupMediator( 'initial_load_error', 
					new PopupViewLogic(null, new InitialLoadErrorViewPopup('Failed to load game', 'Oops, loading failed due to system overload.\nPlease try again later.'), false ), 
					null,
					null),
				OpenPopupCommand.FORCE_OPEN);
		}

		protected function gamelobbyAssetsCompleteHandler( event:Event ):void {
			
			sendNotification( GeneralAppNotifications.TRACK, null, GeneralStatistics.INITIAL_ASSETS_READY );
			sendNotification( GeneralAppNotifications.LOAD_INITIAL_ASSETS_COMPLETE );

			//the preloader will be removed afer INITIAL_DATA_LOADED wwill be called- 
			//the removeChild will be in the MainPreloaderMediator.onRemove()
			try{
				ExternalInterface.call("swf_load_complete");
			}
			catch(event:Error){
				trace(event.message);
			}
		}
	}
}