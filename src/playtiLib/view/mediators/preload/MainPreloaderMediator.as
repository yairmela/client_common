package playtiLib.view.mediators.preload
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.utils.warehouse.GraphicsWarehouseList;
	import playtiLib.view.components.preloaders.MainPreloader;
	import playtiLib.view.components.preloaders.MainPreloaderVLogic;
	import playtiLib.view.mediators.UIMediator;

	/**
	 * @see  playtiLib.view.components.preloaders.MainPreloader
	 * @see playtiLib.utils.warehouse.GraphicsWarehouseList
	 * @see playtiLib.view.mediators.UIMediator
	 */	
	public class MainPreloaderMediator extends UIMediator	{
		
		public static const NAME:String = 'MainPreloaderMediator';
		
		protected var preloader:MainPreloaderVLogic;
		protected var costumPreloader:MainPreloader;
		
		public function MainPreloaderMediator()	
		{
			costumPreloader = new MainPreloader();
			preloader = new MainPreloaderVLogic();
			super( NAME, costumPreloader , true );
		}
		
		private function registerListeners():void
		{
			preloader.content.addEventListener( MainPreloaderVLogic.REMOVE_ANIMATION_FINISHED, onRemoveAnimationFinished );
		}
		
		protected function onRemoveAnimationFinished(event:Event):void
		{
			onRemove();
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
		override public function handleNotification(notification:INotification) : void 
		{
			switch( notification.getName() ) {
				case GeneralAppNotifications.LOAD_CUSTOM_PRELOADER_PROGRESS:
					var progress:ProgressEvent = notification.getBody() as ProgressEvent;
//					costumPreloader.progress =  Math.min( progress.bytesLoaded/progress.bytesTotal, .9 );
					break;
				case GeneralAppNotifications.LOAD_CUSTOM_PRELOADER_COMPLETE:
					addGamePreloader();
					break;
				case GeneralAppNotifications.LOAD_INITIAL_ASSETS_PROGRESS:
					updateProgress( notification.getBody() as ProgressEvent )
					break;
				case GeneralAppNotifications.INITIAL_DATA_LOADED:
					removeAnimation();
					facade.removeMediator( NAME );
					break;
			}
		}
		
		private function removeAnimation():void
		{
			preloader.onRemove();
		}
		/**
		 * Called in case that the LOAD_CUSTOM_PRELOADER_COMPLETE is sent.
		 * It removes the preloader and adds new preloader.
		 * 
		 */		
		protected function addGamePreloader():void 
		{
//			preloader.removeCostumPreloader();
			if( costumPreloader.parent ){
				costumPreloader.parent.removeChild(costumPreloader);
			}
			var preloaderMc:MovieClip = preloader.getGamePreloader();
			registerListeners();
			sendNotification( GeneralAppNotifications.ADD_CHILD_TO_ROOT, preloaderMc );
		}
		/**
		 * Called in case that the LOAD_INITIAL_ASSETS_PROGRESS is sent. 
		 * @param event
		 * 
		 */		
		protected function updateProgress( event:ProgressEvent ):void 
		{
//			preloader.getGamePreloader();
			preloader.updateProgress( event );
		}
		
		/**
		 * Overrides the parent function and adds remove child to the movie clip customPreloader.
		 * 
		 */		
		override public function onRemove() : void 
		{
			//remove the preloader
			super.onRemove();
		}
	}
}