package playtiLib.view.mediators.preload
{
	import flash.display.MovieClip;
	import flash.events.ProgressEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.utils.warehouse.GraphicsWarehouseList;
	import playtiLib.view.components.preloaders.MainPreloader;
	import playtiLib.view.mediators.UIMediator;
	/**
	 * @see  playtiLib.view.components.preloaders.MainPreloader
	 * @see playtiLib.utils.warehouse.GraphicsWarehouseList
	 * @see playtiLib.view.mediators.UIMediator
	 */	
	public class MainPreloaderMediator extends UIMediator	{
		
		public static const NAME:String = 'MainPreloaderMediator';
		
		protected var preloader:MainPreloader;
		protected var custom_preloader:MovieClip;
		
		public function MainPreloaderMediator()	{
			
			super( NAME, new MainPreloader );
			//init generic preloader until the game unique preloader will be ready
			preloader = viewComponent as MainPreloader;
		}
		/**
		 * Returns an array with the notifications the mediator is listening to:
		 * LOAD_CUSTOM_PRELOADER_COMPLETE, LOAD_CUSTOM_PRELOADER_PROGRESS, LOAD_INITIAL_ASSETS_PROGRESS, 
		 * INITIAL_DATA_LOADED.
		 * @param notification
		 * @return 
		 */		
		override public function listNotificationInterests() : Array {
			
			return [ GeneralAppNotifications.LOAD_CUSTOM_PRELOADER_COMPLETE,
					 GeneralAppNotifications.LOAD_CUSTOM_PRELOADER_PROGRESS,
					 GeneralAppNotifications.LOAD_INITIAL_ASSETS_PROGRESS,
					 GeneralAppNotifications.INITIAL_DATA_LOADED];
		}
		/**
		 * Handles the notifications the mediator is listening to:
		 * LOAD_CUSTOM_PRELOADER_COMPLETE, LOAD_CUSTOM_PRELOADER_PROGRESS, LOAD_INITIAL_ASSETS_PROGRESS, 
		 * INITIAL_DATA_LOADED.
		 * @param notification
		 * @return 
		 */		
		override public function handleNotification(notification:INotification) : void {
			
			switch( notification.getName() ) {
				case GeneralAppNotifications.LOAD_CUSTOM_PRELOADER_PROGRESS:
					var progress:ProgressEvent = notification.getBody() as ProgressEvent;
					preloader.progress =  Math.min( progress.bytesLoaded/progress.bytesTotal, .9 );
					break;
				case GeneralAppNotifications.LOAD_CUSTOM_PRELOADER_COMPLETE:
					addCustomPreloader();
					break;
				case GeneralAppNotifications.LOAD_INITIAL_ASSETS_PROGRESS:
					updateProgress( notification.getBody() as ProgressEvent )
					break;
				case GeneralAppNotifications.INITIAL_DATA_LOADED:
					facade.removeMediator( NAME );
					break;
			}
		}
		/**
		 * Called in case that the LOAD_CUSTOM_PRELOADER_COMPLETE is sent.
		 * It removes the preloader and adds new preloader.
		 * 
		 */		
		protected function addCustomPreloader():void {
			//remove the preloader
			if( preloader.parent )
				preloader.parent.removeChild( preloader );
			//add new preloader
			custom_preloader = GraphicsWarehouseList.getAsset( 'game_preloader' ) as MovieClip;
			sendNotification( GeneralAppNotifications.ADD_CHILD_TO_ROOT, custom_preloader );
		}
		/**
		 * Called in case that the LOAD_INITIAL_ASSETS_PROGRESS is sent. 
		 * @param event
		 * 
		 */		
		protected function updateProgress( event:ProgressEvent ):void {
			
			if( !custom_preloader ) // we're still loading the custom preloader
				return
			var ratio:Number = Math.min( event.bytesLoaded/event.bytesTotal, .9 );
			var progress_mc:MovieClip = custom_preloader['progress'] as MovieClip;
			progress_mc.gotoAndStop( Math.ceil( ratio*progress_mc.totalFrames ) );
		}
		/**
		 * Overrides the parent function and adds remove child to the movie clip customPreloader.
		 * 
		 */		
		override public function onRemove() : void {
			
			super.onRemove();
			//remove the custom preloader
			if( custom_preloader && custom_preloader.parent )
				custom_preloader.parent.removeChild( custom_preloader );
		}
	}
}