package playtiLib.view.components.list
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import playtiLib.view.interfaces.IViewLogic;
	/**
	 * A class that implements IViewLogic and auto arranges a display container verticaly.
	 * It gets a width and a Sprite container in it's constructor and has addchild function.  
	 */	
	public class AutoArrangeDisplayContainer implements IViewLogic	{
		
		private var container:Sprite;
		
		public var x_padding:Number = 4;
		public var y_padding:Number = 4;
		
		public var addNewBehind:Boolean = true;
		
		private var width:int;
		
		private var column:int;
		private var row:int;
		
		private var next_x:Number = 0;
		private var next_y:Number = 0;
		
		//in the future when we want this to work horizontaly we will need to implement it
		public function AutoArrangeDisplayContainer( width:Number, container:Sprite = null ){
			
			this.width = width;
			this.container = ( container ) ? container : new Sprite();
		}
		
		public function addChild( child:DisplayObject ):DisplayObject {
			
			child.x = next_x;
			child.y = next_y;
			
			if( ( next_x + x_padding + child.width + child.width ) > width ) {
				next_x = 0;
				next_y += child.height + y_padding;
			} else {
				next_x += child.width + x_padding;
			}
				
			if( addNewBehind )
				container.addChildAt(child, 0);
			else
				container.addChild(child);
			
			return child;
		}
		
		public function get content():DisplayObject {
			return container;
		}
	}
}