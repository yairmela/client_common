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
	import playtiLib.model.proxies.config.HelpProxy;
	import playtiLib.model.proxies.config.HostProxy;
	import playtiLib.model.proxies.config.VersionProxy;
	import playtiLib.model.proxies.data.XMLProxy;
	import playtiLib.model.proxies.load.LoadConfigProxy;
	import playtiLib.utils.load.MultiLoadManager;
	import playtiLib.utils.locale.TextLib;
	import playtiLib.utils.network.URLUtil;
	import playtiLib.utils.sounds.SoundsLib;
	import playtiLib.utils.statistics.Tracker;
	import playtiLib.utils.tracing.Logger;
	import playtiLib.utils.warehouse.GraphicsWarehouseList;
	import playtiLib.utils.warehouse.SWFGraphicsWarehouse;
	import playtiLib.view.components.popups.InitialLoadErrorViewPopup;
	import playtiLib.view.components.popups.PopupViewLogic;
	import playtiLib.view.mediators.popups.PopupMediator;
	import playtiLib.view.mediators.preload.MainPreloaderMediator;

	/**
	 * Gets path from the notification's body, registers a preloadMediator and load the xml from the given path. It loads the custom
	 * preloader and the main assets that contain : strings, sounds and graphics, host, help and version. 
	 * When the preloaders complete loading, thay send relevant notifications. It also sends progress notifications for the custom preloader and for
	 * the main preloader (assets).
	 * @see playtiLib.model.proxies.config.HelpProxy
	 * @see playtiLib.model.proxies.config.HostProxy
	 * @see playtiLib.model.proxies.config.VersionProxy
	 * @see playtiLib.model.proxies.data.XMLProxy
	 * @see playtiLib.view.mediators.preload.MainPreloaderMediator
	 */	
	public class LoadExternalsCommand extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {
			//we recive the config xml path
			var load_config_path:String = notification.getBody() as String;
			// if runned from web - create uniq request
			if( !URLUtil.isRunnedLocaly() )
				load_config_path += "?nocache=" + Math.random(); 
			//init a prelaoder view and register its mediator
			facade.registerMediator( new MainPreloaderMediator() );
			//load the loading config xml
			var xml_loader:URLLoader = new URLLoader();
			
			xml_loader.addEventListener( Event.COMPLETE, xmlLoadComplete );
			xml_loader.addEventListener( IOErrorEvent.IO_ERROR,  trace );
			xml_loader.load( new URLRequest( load_config_path ) );
			
			sendNotification( GeneralAppNotifications.TRACK, null, GeneralStatistics.INITIAL_ASSETS_LOAD_START );
				//TODO: add error event incase we have load problems
				//TODO: implement simple xmlLoader that will try another load when the first fail and only than will raise error event
				//TODO: sendNotification + general fail dialog for application fail when you didnt load after the second try
			
		}
		/**
		 * The function is called when the xml file completes loaded. It logges that the xml when it ready, loads the custom preload and
		 * the main preloader assets.  
		 * @param event
		 * 
		 */		
		protected function xmlLoadComplete( event:Event ):void {
			
			Logger.log( "load_xml_config ready" );
			//parse the load_config.xml string to XML
			var load_config:XML = new XML( event.target.data );
			//register load external proxy for reusable of xml data
			facade.registerProxy( new LoadConfigProxy( LoadConfigProxy.NAME, null, load_config ) );
			//load initial assets
			loadCustomPreloadResource( load_config );
			loadMainResource( load_config );
		}
		/**
		 * Gets a xml file, inits multiloader and registers events(progress, complete, errors) and loads the custom preloader. 
		 * The function goes over all libraries in the xml ( resources.preload.libraries.library ), adds them to manager loader with 
		 * SWFGraficWarehouse and loads the swf.  
		 * @param load_config
		 * 
		 */		
		protected function loadCustomPreloadResource( load_config:XML ):void {
			//load custom preloader resources
			//init multiLoader and register to its events
			var preloader_m_loader:MultiLoadManager = new MultiLoadManager;
			preloader_m_loader.addEventListener( ProgressEvent.PROGRESS, preloadingAssetsProgressHandler );
			preloader_m_loader.addEventListener( Event.COMPLETE, preloadingAssetsCompleteHandler );
			preloader_m_loader.addEventListener( IOErrorEvent.IO_ERROR, IO_Error );
			//go over all libraries register them and initiate thier loading.
			var graphic_library:SWFGraphicsWarehouse;
			for each( var library:XML in load_config.resources.preload.libraries.library ) {
				graphic_library = new SWFGraphicsWarehouse();
				GraphicsWarehouseList.addNewWarehouse( graphic_library );
				//add it to the multiload manager
				preloader_m_loader.addLoadingProcess( graphic_library, SWFGraphicsWarehouse, Event.COMPLETE );
				//start load swf
				graphic_library.load( ServerConfig.ASSETS_SERVER_IP + library.@url );
			}
		}
		
		protected function IO_Error( event:IOErrorEvent ):void{
			
			trace(event);
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
			var game_lobby_m_loader:MultiLoadManager = new MultiLoadManager;
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
					//TODO: can we delete it??
		/*			if(library.@url == 'res/warehouses/initial_assets.swf') {
						currentURL = 'res/en/'+library.@url;
					}
		*/			graphic_library.load( current_url );
				//	graphicLibrary.load( ServerConfig.ASSETS_SERVER_IP + library.@url );
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
		//TODO: change the msg to different msg(not slotomania) - ask Amir for a new text.
		/**
		 * Sends notification OPEN_POPUP when there is an error. It force open the pop up that says that the user failed to load Slotomania.
		 * @param event
		 * 
		 */		
		protected function criticalAssetIOError( event:Event ):void {
			
			sendNotification( GeneralAppNotifications.OPEN_POPUP,
				new PopupMediator( 'initial_load_error', 
					new PopupViewLogic(null, new InitialLoadErrorViewPopup('Failed to load game', 'Oops, loading failed due to system overload.\nPlease try again later.'), false ), 
					null,
					null),
				OpenPopupCommand.FORCE_OPEN);
		}
		/**
		 * Tracks INITIAL_ASSETS_READY and sends notification LOAD_INITIAL_ASSETS_COMPLETE. The function called when
		 * there is event (COMPLETE) on the main preloader manager. 
		 * @param event
		 * 
		 */		
		protected function gamelobbyAssetsCompleteHandler( event:Event ):void {
			
			sendNotification( GeneralAppNotifications.TRACK, null, GeneralStatistics.INITIAL_ASSETS_READY );
			//notify load complete
			sendNotification( GeneralAppNotifications.LOAD_INITIAL_ASSETS_COMPLETE );
			//the preloader preloader will be removed afer INITIAL_DATA_LOADED wwill be called- the removeChild will be in the MainPreloaderMediator.onRemove()
			//TODO: replace with if externalInterface.is_avilable
			try{
				ExternalInterface.call("swf_load_complete");
			}
			catch(event:Error){
				trace(event.message);
			}
		}
	}
}