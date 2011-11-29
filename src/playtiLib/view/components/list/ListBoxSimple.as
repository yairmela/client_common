package playtiLib.view.components.list
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	/**
	 * Holds a ScrollSimple and a ListWindowSimple objects.
	 */	
	public class ListBoxSimple extends EventDispatcher{
		
		static protected const SCROLL_NAME : String = "scroll";
		static protected const LIST_NAME : String 	= "listItems";
		
		protected var scroll : ScrollSimple;
		protected var list : ListWindowSimple;
		
		public function ListBoxSimple( content : DisplayObjectContainer ){
			
			super( content );
			list = new ListWindowSimple( content.getChildByName( LIST_NAME ) as MovieClip );
			//TODO: can we delete this?
			//var scrollAdditionalParams : Object = CommonUtils.getFieldSafe(additionalParams, "scrollParams", {direction: WindowDirected.VERTICAL});
			scroll = new ScrollSimple( content.getChildByName( SCROLL_NAME ) as MovieClip ) ;
			
			list.AttachScroll( scroll );
		}
		//TODO: can we delete this function?
		/*override public function Destroy( removeContentFromStage : Boolean = true ) : void
		{
			list.Destroy(removeContentFromStage);
			scroll.Destroy(removeContentFromStage);
			
			super.Destroy(removeContentFromStage);
		}*/
		
		public function GetListWindow() : ListWindowSimple	{
			
			return list;
		}
		
		public function GetScroll() : ScrollSimple{
			
			return scroll;
		}
	}
}