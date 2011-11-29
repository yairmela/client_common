package playtiLib.view.mediators.core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.utils.tracing.Logger;
	/**
	 * @see  org.puremvc.as3.patterns.mediator.Mediator
	 */
	public class RootMediator extends Mediator {
		
		public static const NAME:String = 'CoreMediator';

		private var root_view:Sprite;

		public function RootMediator( root:Sprite )	{
			
			super( NAME, root );
			Logger.log( "CoreMediator mainView =" + root );
			this.root_view = root;
			
			if(root_view.stage.displayState != StageDisplayState.FULL_SCREEN) {
				fullscreen = false;
			}
		}
		/**
		 * Returns the an array with all the notification this mediator listens for.
		 * The notifications are: FULLSCREEN_MODE, ADD_CHILD_TO_ROOT, ADD_CHILD_TO_ROOT_AT, 
		 * ADD_CHILD_TO_ROOT_AT_BOTTOM.
		 * @return 
		 * 
		 */
		override public function listNotificationInterests():Array {
			
			return [ GeneralAppNotifications.FULLSCREEN_MODE,
					 GeneralAppNotifications.ADD_CHILD_TO_ROOT,
					 GeneralAppNotifications.ADD_CHILD_TO_ROOT_AT,
					 GeneralAppNotifications.ADD_CHILD_TO_ROOT_AT_BOTTOM ];
		}
		/**
		 * Handles the notifications that this mediator are listens for.
		 * the notifications are: FULLSCREEN_MODE, ADD_CHILD_TO_ROOT, ADD_CHILD_TO_ROOT_AT,
		 * ADD_CHILD_TO_ROOT_AT_BOTTOM
		 * @param notification
		 * 
		 */
		override public function handleNotification( notification:INotification ):void {
			
			switch( notification.getName() ) {
				case GeneralAppNotifications.FULLSCREEN_MODE:
					fullscreen = notification.getBody() as Boolean;
					break;
				case GeneralAppNotifications.ADD_CHILD_TO_ROOT:
					addChildToRoot( notification.getBody() as DisplayObject );
					break;
				case GeneralAppNotifications.ADD_CHILD_TO_ROOT_AT:
					var params:Object = notification.getBody();
					addChildToRootAt( params.child as DisplayObject, params.index );
					break;
				case GeneralAppNotifications.ADD_CHILD_TO_ROOT_AT_BOTTOM:
					addChildToRootAt( notification.getBody() as DisplayObject, 0 );
					break;
			}
		}
		/**
		 * Adds a display object to the root and returns it. 
		 * @param child The display object that added to root.
		 * @return 
		 * 
		 */
		private function addChildToRoot( child:DisplayObject ):DisplayObject {
			
			return addChildToRootAt( child, root_view.numChildren );
		}
		/**
		 * Adds a display object to the root at some index and return it. 
		 * @param child The display object that added to root.
		 * @param index this index that the child added to.
		 * @return 
		 * 
		 */
		private function addChildToRootAt( child:DisplayObject, index:int ):DisplayObject {
			index = Math.min( index, root_view.numChildren )
			return root_view.addChildAt( child, index );
		}

		private function set fullscreen( value:Boolean ):void{
			
			if( value ) {
				root_view.stage.scaleMode 		= StageScaleMode.NO_SCALE;
				root_view.stage.displayState 	= StageDisplayState.FULL_SCREEN;
			}
			else {
				root_view.stage.scaleMode 		= StageScaleMode.EXACT_FIT;
				root_view.stage.displayState 	= StageDisplayState.NORMAL;
			}
		}
	}
}