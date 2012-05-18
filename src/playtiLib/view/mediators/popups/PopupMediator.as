package playtiLib.view.mediators.popups
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.vo.popup.PopupDoActionVO;
	import playtiLib.model.proxies.popup.ActivePopupsProxy;
	import playtiLib.utils.statistics.Tracker;
	import playtiLib.view.components.btns.ButtonSimple;
	import playtiLib.view.components.popups.PopupViewLogic;
	import playtiLib.view.mediators.UIMediator;

	/**
	 * Holds do and close (VO) objects, a PopupViewLogic object, a boolean modal_mode var and a sprite object (modal_background). Sets mouseEvent listeners 
	 * for all the buttons, can auto-center the popup, can draw a black screen behind the popup (on registration). It also handles the do and close
	 * mouseClicks by sending notifications. 
	 * @see playtiLib.view.mediators.UIMediator
	 * @see playtiLib.view.components.popups.PopupViewLogic
	 * @see playtiLib.model.proxies.popup.ActivePopupsProxy
	 */	
	public class PopupMediator extends UIMediator	{
		
		protected var modal_mode:Boolean;
		protected var modal_background:Sprite;
		protected var do_action_vo:PopupDoActionVO;
		protected var close_action_vo:PopupDoActionVO;
		protected var popup_logic:PopupViewLogic;
		protected var autoCenter_mode:Boolean;
		
		public function PopupMediator( mediatorName:String, popupViewLogic:PopupViewLogic, doActionVO:PopupDoActionVO=null, closeActionVO:PopupDoActionVO=null, modal_mode:Boolean = true, autoCenter_mode:Boolean = true )	{
			
			super( mediatorName, popupViewLogic );
			popup_logic 		= popupViewLogic;
			this.modal_mode 	= modal_mode;
			this.do_action_vo 	= doActionVO;
			this.close_action_vo 	= closeActionVO;
			this.autoCenter_mode 	= autoCenter_mode;
			registerCloseDoListeners();
			if( autoCenter_mode )
				popup_logic.content.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true );
		}
		/**
		 *  Sends notification ADD_CHILD_TO_ROOT, make sure the active popups proxy is registered
		 *  and add popup to active list.
		 * 
		 */		
		override public function onRegister():void {
			
			if( modal_mode ) {
				modal_background = drawModalBG( new Sprite, 1, 1 );
				sendNotification( GeneralAppNotifications.ADD_CHILD_TO_ROOT, modal_background );
			}
			//make sure the active popups proxy is registered
			if( !facade.hasProxy( ActivePopupsProxy.NAME ) )
				facade.registerProxy( new ActivePopupsProxy );
			//add popup to active list
			( facade.retrieveProxy( ActivePopupsProxy.NAME ) as ActivePopupsProxy ).addPopup( this );
			super.onRegister();			
		}
		
		protected function onAddedToStage( event : Event ) : void {
			
			centerPopup();
		}
		/**
		 * Adds event listeners to all the close and do buttons. 
		 * 
		 */		
		protected function registerCloseDoListeners():void {
			
			for each( var close_btn:ButtonSimple in popup_logic.close_btns_list ) {
				close_btn.addEventListener( MouseEvent.CLICK, closePopup, false, 0, true );
			}
			if( do_action_vo != null ) {
				for each( var do_btn:ButtonSimple in popup_logic.do_btns_list ) {
					do_btn.addEventListener( MouseEvent.CLICK, doActionHandler, false, 0, true );
				}
			}
		}
		/**
		 * Handles the mouse event ( CLICK ) on the do button.
		 * @param event
		 * 
		 */		
		protected  function doActionHandler( event:Event ):void {
			
			if( !do_action_vo )
				return;
			var do_btn:ButtonSimple = event.currentTarget as ButtonSimple;
			var do_id:int = popup_logic.do_btns_list.indexOf(do_btn);
			sendNotification( do_action_vo.notificationById(do_id), do_action_vo.notificationBodyById(do_id), do_action_vo.notificationTypeById(do_id) );
			var track_string:String = do_action_vo.notificationTrackStringById( do_id );
			if( track_string!=null )
				sendNotification( GeneralAppNotifications.TRACK, null, track_string );
			if( do_action_vo.closeAfterById(do_id) )
				facade.removeMediator(mediatorName);
		}
		/**
		 * Handles the close button mouse event (CLICK).
		 * @param event
		 * 
		 */		
		public function closePopup( event:Event = null ):void {
			
			//close popup
			facade.removeMediator( mediatorName );
			//return if ther is no close reaction
			if( !close_action_vo )
				return;
			//handle after close notification
			var close_id:int = 0;
			var close_notification:String = close_action_vo.notificationById(close_id);
			if( close_notification )
				sendNotification( close_notification, close_action_vo.notificationBodyById(close_id), close_action_vo.notificationTypeById(close_id) );
			//habdle after close tracking
			var track_string:String = close_action_vo.notificationTrackStringById( close_id );
			if( track_string!=null )
				sendNotification( GeneralAppNotifications.TRACK, null, track_string );
		}
		/**
		 *
		 * Returns an array with the notification the mediator is listening to:
		 * FULLSCREEN_MODE.
		 * @param notification
		 * @return 
		 */		
		public override function listNotificationInterests():Array {
			
			return [
				GeneralAppNotifications.FULLSCREEN_MODE
			];
		}
		/**
		 * Handles the notification the mediator is listening to:
		 * FULLSCREEN_MODE.
		 * @param notification
		 * 
		 */
		public override function handleNotification(notification:INotification):void {
			
			switch( notification.getName() ) {
				case GeneralAppNotifications.FULLSCREEN_MODE:
					if (autoCenter_mode) {
						centerPopup();
					}
					break;
			}
		}
		/**
		 * Draws the model bg.  
		 * @param shape
		 * @param width
		 * @param height
		 * @return 
		 * 
		 */		
		private function drawModalBG( shape:Sprite, width:int, height:int ):Sprite {
			shape.name = 'mcModalBG';
			with( shape.graphics ) {
				clear();
				beginFill( 0,.5 );
				drawRect( 0,0,width,height );
			}
			return shape;
		}
		
		private function centerPopup() : void
		{
			popup_logic.centerPopup();
			
			if(modal_background) {
				var stage : Stage = popup_logic.content.stage;
				modal_background.width = stage.stageWidth;
				modal_background.height = stage.stageHeight;
				modal_background.x = -(modal_background.width - PopupViewLogic.POPUPS_CENTER_TO_WIDTH) / 2;
				modal_background.y = -(modal_background.height - PopupViewLogic.POPUPS_CENTER_TO_HEIGHT) / 2;
			}
		}
		/**
		 * Overrides the parent's function and adds it some functionality include
		 * remove popup from active list, remove modal background and call for next popup.
		 * 
		 */		
		override public function onRemove():void {
			
			super.onRemove();
			popup_logic.onRemove();
			//remove popup from active list
			(facade.retrieveProxy( ActivePopupsProxy.NAME ) as ActivePopupsProxy).removePopup( this );
			//remove modal background
			if( modal_background && modal_background.parent )
				modal_background.parent.removeChild( modal_background );
			//call for next popup
			sendNotification( GeneralAppNotifications.SHOW_NEXT_POPUP );
		}
	}
}