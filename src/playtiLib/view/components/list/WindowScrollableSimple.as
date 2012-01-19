package playtiLib.view.components.list
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import playtiLib.view.components.btns.SliderSimple;
	
	public class WindowScrollableSimple extends EventDispatcher{
		
		static protected const VIEWPORT_NAME : String 			= "viewportMask";
		static protected const SCROLLABLE_CONTENT_NAME : String = "scrollableContent";
		static public const VERTICAL   : String 				= "vertical";
		static public const HORIZONTAL : String 				= "horizontal";
		
		protected var scroll_attached : Object;
		
		protected var view_port : DisplayObject;
		protected var scrollable_content : DisplayObjectContainer;
		protected var o_cur_scroll:ScrollSimple;
		
		public function WindowScrollableSimple( content : DisplayObjectContainer ){
			
			super( content );
			
			scroll_attached = new Object();
			
			view_port = content.getChildByName(VIEWPORT_NAME);
			if( !view_port ) {
				throw new Error( "Child \"" + VIEWPORT_NAME + "\" was not found." );
				
				return;
			}
			var back : Bitmap;
			back = new Bitmap(new BitmapData(view_port.width,viewport.height));
			back.bitmapData.draw(view_port);
			back.alpha = 0;
			content.addChildAt(back,0);
			
			scrollable_content = content.getChildByName( SCROLLABLE_CONTENT_NAME ) as DisplayObjectContainer;
			
			if( !scrollable_content ) {
				throw new Error("Child \""+SCROLLABLE_CONTENT_NAME+"\" was not found.");
				return;
			}
			scrollable_content.mask = view_port;
		}
		
		public function Destroy( removeContentFromStage : Boolean = true ) : void{
			
			for( var scrolling_direction : String in scroll_attached ) {
				detachScroll( scrolling_direction );
			}
			scroll_attached = null;
			//TODO: clean the code from junk
			//super.Destroy(removeContentFromStage);
		}
		
		public function AttachScroll( scroll : ScrollSimple, scrollingDirection : String = null ) : void{
			
			var prev_scroll : ScrollSimple = scroll_attached[scrollingDirection];
			o_cur_scroll = scroll;
			if( prev_scroll ) 
				detachScroll( scrollingDirection );
			
			if( !scrollingDirection ) 
				scrollingDirection = scroll.direction;
			
			if( scrollingDirection == HORIZONTAL ) {
				scroll.addEventListener( MouseEvent.CLICK, onScrollHorizontal );
				scroll.addEventListener( MouseEvent.MOUSE_MOVE, onScrollHorizontal );
				scroll.addEventListener( Event.MOUSE_LEAVE, onScrollHorizontal );
			}
			else {
				scroll.addEventListener( MouseEvent.CLICK, onScrollVertical );
				scroll.addEventListener( MouseEvent.MOUSE_MOVE, onScrollVertical );
				scroll.addEventListener( Event.MOUSE_LEAVE, onScrollVertical );
			}
			
			scroll_attached[scrollingDirection] = scroll;
			
			checkScrollingSuitable( scrollingDirection );
		}
		
		protected function detachScroll( scrollingDirection : String ) : void{
			
			var scroll : ScrollSimple = scroll_attached[scrollingDirection];
			scroll.enabled = true;
			
			if( scrollingDirection == HORIZONTAL ) {
				scroll.removeEventListener( MouseEvent.CLICK, onScrollHorizontal );
				scroll.removeEventListener( MouseEvent.MOUSE_MOVE, onScrollHorizontal );
				scroll.removeEventListener( Event.MOUSE_LEAVE, onScrollHorizontal );
			}
			else {
				scroll.removeEventListener( MouseEvent.CLICK, onScrollVertical );
				scroll.removeEventListener( MouseEvent.MOUSE_MOVE, onScrollVertical );
				scroll.removeEventListener( Event.MOUSE_LEAVE, onScrollVertical );
				scroll.removeEventListener( MouseEvent.MOUSE_WHEEL, onScrollVertical );
			}
			
			delete scroll_attached[scrollingDirection];
		}
		
		public function get scrollableContent() : DisplayObjectContainer{
			
			return scrollable_content;
		}
		
		public function get viewport() : DisplayObject{
			
			return view_port;
		}
		
		protected function onScrollHorizontal( event : MouseEvent ) : void
		{
			if (event.delta){
				var deltaScroll:Number = 2*event.delta;
				mouseWhell(deltaScroll,HORIZONTAL, "x", "width")
			}
			else
				setScrollPercent( (event.currentTarget as ScrollSimple).value, "x", "width" );
		}
		
		protected function onScrollVertical( event:MouseEvent ) : void	{

			if (event.delta){
				var deltaScroll:Number = 2*event.delta;
				mouseWhell(deltaScroll,VERTICAL, "y", "height")
			}
			else
				setScrollPercent( (event.currentTarget as ScrollSimple).value, "y", "height" );
			//Log("Scroll dragged !!!!!!!!!!!"+scrollAttached[WindowDirected.VERTICAL].value);
		}
		
		protected function setScrollPercent( value:Number, variableName:String, rangeName:String ):void	{
			
			var diff : Number = getScrollingDiff( rangeName );
			
			if( !diff ) 
				return;
			scrollableContent[variableName] = viewport[variableName] - ( diff * value );
		}
		private function mouseWhell(deltaScroll:Number,scrollingDirection:String,variableName : String, rangeName : String):void{
			var scroll:SliderSimple =  scroll_attached[scrollingDirection] as SliderSimple ;
			if( (scrollable_content[variableName] + deltaScroll < viewport[variableName]) && 
				(scrollable_content[variableName] + scrollable_content[rangeName]+ deltaScroll > viewport[variableName]+viewport[rangeName])  ){
					scrollable_content[variableName] += deltaScroll;
					scroll.value =-(scrollable_content[variableName]/(scrollable_content[rangeName] - viewport[rangeName]));
			}
		}
		protected function getScrollingDiff( rangeName : String ) : Number
		{
			return (scrollableContent[rangeName] - viewport[rangeName]);
		}
		
		protected function checkScrollingSuitable( scrollingDirection : String ) : Boolean{
			
			var is_suitable : Boolean;
			var diff : Number;
			var range_name : String;
			var variable_name : String;
			
			if( scrollingDirection == HORIZONTAL ) {
				range_name = "width";
				variable_name = "x";
			}
			else {
				range_name = "height";
				variable_name = "y";
			}
			
			diff = getScrollingDiff( range_name );
			
			is_suitable = ( diff > 0 );
			
			var scroll : ScrollSimple = scroll_attached[scrollingDirection];
			
			if( scroll ) {
				if( !is_suitable ) {
					scroll.value = 0;
				}
				
				scroll.enabled = is_suitable;
				
				setScrollPercent( scroll.value, variable_name, range_name );
			}
			
			return is_suitable;
		}
	}
}