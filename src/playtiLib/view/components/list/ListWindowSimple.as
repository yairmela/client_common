package playtiLib.view.components.list
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import playtiLib.view.components.btns.RadioGroupSimple;
	
	public class ListWindowSimple extends WindowScrollableSimple
	{
		protected var items_group : RadioGroupSimple;
		
		protected var item_shift : Point;
		
		protected var itemLogicClass : Class;
		protected var item_additional_params : Object;
		
		
		public function ListWindowSimple( content : DisplayObjectContainer, additionalParams : Object=null ){
			
			super( content );
			
			var item_data : Object = getFieldSafe( null, "itemData" );
			
			item_shift = new Point( getFieldSafe( item_data, "shiftX", 0 ),
									getFieldSafe( item_data, "shiftY", 0 ) );
									
			items_group = new RadioGroupSimple();
			
			items_group.addEventListener( Event.CHANGE, dispatchEvent );
			
			itemLogicClass = getFieldSafe( item_data, "logicClass", ListItemSimple );
			item_additional_params = getFieldSafe( item_data, "additionalParams", new Object() );
			item_additional_params["parentContent"] = scrollableContent;
		}
		
		/**
		 * TODO: 
		 * */
		public function get itemsRadioGroup():RadioGroupSimple {
			
			return items_group;
		}
		
		static public function getFieldSafe( obj:Object, field:*, defaultValue:* = null ) : * {
			
			var result : Object;
			
			try {
				if( obj.hasOwnProperty(field) ) {
					result = obj[field];
				}
				else {
					result = defaultValue;
				}
			}
			catch( error : Error ) {
				result = defaultValue;
			}
			return result;
		}
		 
		override public function Destroy( removeContentFromStage:Boolean = true ):void {
			
			RemoveItems();
			
			items_group.removeEventListener( Event.CHANGE, dispatchEvent );
			items_group.Destroy();
			
			super.Destroy( removeContentFromStage );
		}
		
		override public function AttachScroll( scroll:ScrollSimple, scrollingDirection:String = null ):void	{
			
			if( !scrollingDirection ) 
				scrollingDirection = scroll.direction;

			super.AttachScroll( scroll, scrollingDirection );
			//TODO:junks?
			/*if(scrollingDirection == WindowDirected.VERTICAL) {
				scroll.delta = (1 / length);
			}*/
		}
		
		public function AddItem( itemDisplay:*, additionalParams:Object = null ):ListItemSimple	{
			
			if( !additionalParams )  
				additionalParams = item_additional_params;
			else {
				for( var i:String in item_additional_params) {
					additionalParams[i] = item_additional_params[i];
				}
			}
			var item_pos_y:Number = scrollableContent.height;
			
			if( length ) 
				item_pos_y += item_shift.y;
			var item : ListItemSimple = new itemLogicClass( itemDisplay )as ListItemSimple;
			items_group.AddRadioButton( item );
			checkScrollingSuitable( VERTICAL );
			return item;
		}

		public function RemoveItems( startFromItem:* = 0, itemsCount:uint = uint.MAX_VALUE, removeContentFromStage:Boolean = true ):void {
			
			var index:uint;
			if( startFromItem is Number )  
				index = startFromItem;
			else if( startFromItem is EventDispatcher ) {
				index = items_group.GetRadioButtonIndex( startFromItem );
				if( index == -1 ) {
					//TODO:delete?
					//LogError("Wrong \"startFromItem\" value ("+startFromItem+") - item was not found.");
					return;				
				}
			}
			else {
				//LogError("Wrong \"startFromItem\" param type (Number or WindowBase expected).");
				//TODO:delete??
				return;
			}
			var item:ListItemSimple = items_group.GetRadioButton( index ) as ListItemSimple;
			
			if( !item ) {
				return;
			}
			
			var dest_y:Number = item.content.y;
			var items_end_count:uint = ( index + itemsCount );
			for( var i:int = ( ( items_end_count > length ) ? ( length - 1 ) : ( items_end_count - 1 ) ); i >= index; i-- ) {
				item = items_group.RemoveRadioButton(i) as ListItemSimple;
				//TODO:delete?
				//item.Destroy(removeContentFromStage);
			}
			var item_content:DisplayObject;
			for( i = index; i < length; i++ ) {
				item_content = items_group.GetRadioButton(i).content;
				item_content.y = dest_y;
				dest_y += item_content.height + item_shift.y;
			}
			checkScrollingSuitable( VERTICAL );
		}
		
		public function GetItem( index:uint ):ListItemSimple { 
			
			return ( items_group.GetRadioButton( index ) as ListItemSimple );
		}
		
		public function GetItemIndex( item:ListItemSimple ):int {
			
			return items_group.GetRadioButtonIndex( item );
		}
		
		public function set currentItemIndex( index:int ):void {
			
			if( ( index < -1) || ( index >= items_group.length ) ) 
				index = -1;
			
			items_group.current = index;
		}
		
		public function get currentItemIndex():int {
			
			return items_group.current;
		}
		
		public function get currentItem():ListItemSimple{
			
			return GetItem( items_group.current );
		}
		
		public function get length() : uint{
			
			return items_group.length;
		}
		
		override protected function checkScrollingSuitable( scrollingDirection:String ):Boolean{
			
			if( scrollingDirection == VERTICAL ) {
				var scroll : ScrollSimple = scroll_attached[scrollingDirection];
				if( scroll )  
					scroll.delta =  (1 / length );
			}
			
			return super.checkScrollingSuitable( scrollingDirection );
		}
	}
}