package playtiLib.view.mediators
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.utils.locale.TextLib;
	import playtiLib.view.interfaces.IViewLogic;
	
	public class UIMediator extends Mediator {
		
		protected var add_at_bottom:Boolean;
		
		
		public function UIMediator( mediatorName:String=null, viewComponent:Object=null, add_at_bottom:Boolean=false ){
			
			super( mediatorName, viewComponent );
			this.add_at_bottom = add_at_bottom;
		}
		
		protected function get content():DisplayObject {
			
			return ( viewComponent is IViewLogic )? ( viewComponent as IViewLogic ).content : viewComponent as DisplayObject
		}

		override public function onRegister():void {
			
			sendNotification( add_at_bottom? GeneralAppNotifications.ADD_CHILD_TO_ROOT_AT_BOTTOM : GeneralAppNotifications.ADD_CHILD_TO_ROOT, content );
		}
		
		override public function onRemove():void {
			
			if( content && content.parent )
				content.parent.removeChild( content );
		}
	}
}
