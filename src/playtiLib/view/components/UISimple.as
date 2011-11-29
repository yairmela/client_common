package playtiLib.view.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import playtiLib.view.interfaces.IViewLogic;
	/**
	 * UI simple class that holds a Sprite object  
	 */	
	public class UISimple extends EventDispatcher implements IViewLogic{
		
		protected var target:Sprite;
		
		public function UISimple( target:Sprite )	{
			
			super( target );
			this.target = target;
		}
		
		public function get content():DisplayObject	{
			
			return target;
		}
	}
}