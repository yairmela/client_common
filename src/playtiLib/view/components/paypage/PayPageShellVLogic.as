package playtiLib.view.components.paypage
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.view.components.popups.PopupViewLogic;
	import playtiLib.view.interfaces.IPayPage;
	import playtiLib.view.interfaces.IViewLogic;
	/**
	 * Represents the pay page shell 
	 */	
	public class PayPageShellVLogic extends PopupViewLogic implements IViewLogic{
		
		public function PayPageShellVLogic( pay_page_loader:Loader ){
			
			super( null, pay_page_loader );
			pay_page_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadComplete );
		}
		/**
		 * Handles the pay page loader info COMPLETE event. It adds another event
		 * listeners to the loder info. 
		 * @param event
		 * 
		 */		
		private function loadComplete( event:Event ):void {
			
			( event.currentTarget as LoaderInfo ).content.addEventListener( Event.ADDED, centerPopup );
			( event.currentTarget as LoaderInfo ).content.addEventListener( Event.CLOSE, dispatchEvent );
			( event.currentTarget as LoaderInfo ).content.addEventListener( EventTrans.DATA, dispatchEvent );
		}
		/**
		 * Function that handles the ADDED event and places the popup in the center of the stage  
		 * @param event
		 * 
		 */		
		override public function centerPopup():void {
			
//			var page:DisplayObject 		= event.currentTarget as DisplayObject;
//			page.removeEventListener( Event.ADDED, centerPopup );
//			addition_popup_display.x 	= -page.width/2;
//			addition_popup_display.y 	= -page.height/2;
			setPosition( addition_popup_display.stage.stageWidth / 2, addition_popup_display.stage.stageHeight / 2 );
		}
		
		private function get pay_page_loader():Loader {
			
			return addition_popup_display as Loader;
		}
		
		public function get pay_page():IPayPage {
			
			return pay_page_loader.content as IPayPage
		}
	}
}