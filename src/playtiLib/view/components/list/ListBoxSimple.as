package playtiLib.view.components.list
{
	import flash.display.DisplayObject;
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
			scroll = new ScrollSimple( content.getChildByName( SCROLL_NAME ) as MovieClip ) ;
			
			list.AttachScroll( scroll );
		}
		
		public function GetListWindow() : ListWindowSimple	{
			
			return list;
		}
		
		public function GetScroll() : ScrollSimple{
			
			return scroll;
		}
	}
}