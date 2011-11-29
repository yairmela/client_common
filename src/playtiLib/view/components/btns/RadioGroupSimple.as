package playtiLib.view.components.btns
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import playtiLib.utils.events.EventTrans;
	/**
	 * Hanles a group of RadioButtonSimple objects. It has functions that can adds, removes,
	 * gets and handles mouse click on the RadioButtonSimple objects in the group. 
	 */	
	public class RadioGroupSimple extends EventDispatcher{
		
		protected var radio_buttons_arr:Array;
		protected var current_index:int;
		
		public function RadioGroupSimple(){
			
			super();
			//TODO: do we need this line?
			//SetMgrContainer( MgrContainer.GetInstance() );
			radio_buttons_arr = new Array();
			current_index = -1;
		}
		
		protected function redispatchEvent( event:Event ):void{
			
			dispatchEvent( event.clone() );
			event.stopImmediatePropagation();
			//TODO: can we delete this junk?
			/*dispatchEvent( new MouseEvent(event.type, event.bubbles, event.cancelable, event.localX, event.localY,
			event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta,
			false, event.ctrlKey, 0) );*/
		}
		
		public function Destroy():void{
			
			radio_buttons_arr.splice(0);
			radio_buttons_arr = null;
			current_index = -1;
		}
		/**
		 * Adds the RadioButtonSimple object to the array of the radio btn objects.
		 * It also add event listener to click on this radio btn.
		 * @param radioBtn
		 * @return 
		 * 
		 */		
		public function AddRadioButton( radioBtn :RadioButtonSimple ):RadioButtonSimple	{
			
			radio_buttons_arr.push( radioBtn );
			radioBtn.addEventListener( MouseEvent.CLICK, onRadioButtonClick );
			return radioBtn;
		}
		/**
		 *  Gets a radio btn id and removes it from the radio btn group. The function 
		 *  can handles two cases: 1. a number id - this is the index of the radio btn inside the
		 * 	array of tje radio btn. 2. a RadioButtonSimple - the function removes this btn from the 
		 *  group 
		 * @param radioBtnId It can be a Number type or a RadioButtonSimple object.
		 * @return RadioButtonSimple
		 * 
		 */		
		public function RemoveRadioButton( radioBtnId:* ):RadioButtonSimple{
			
			var index:Number;
			if( radioBtnId is Number ) {
				index = radioBtnId;
			}
			else if( radioBtnId is RadioButtonSimple ) {
				index = GetRadioButtonIndex( radioBtnId );
				
				if(index == -1) {
					//TODO: do we need this junk?
					//LogError("Can't remove radio button "+radioBtnId+" - item was not found.");
					return null;
				}
			}
			else {
				//TODO: do we need this junk?
				//LogError("Wrong \"radioBtnId\" param type (Number or RadioButtonSimple expected).");
				
				return null;
			}
			var radio_btn:RadioButtonSimple = radio_buttons_arr[index];
			radio_buttons_arr.splice( index, 1 );
			radio_btn.removeEventListener( MouseEvent.CLICK, onRadioButtonClick );
			
			return radio_btn;
		}
		/**
		 * Gets an index of a radio btn and returns the radio btn that in that index in the array of the radio btns. 
		 * @param index
		 * @return 
		 * 
		 */		
		public function GetRadioButton( index:uint ):RadioButtonSimple{
			
			return radio_buttons_arr[index];
		}
		/**
		 * Gets a radio btn and returns the index of this btn inside the radio btn array  
		 * @param radioBtn An RadioButtonSimple object
		 * @return int
		 * 
		 */		
		public function GetRadioButtonIndex( radioBtn:RadioButtonSimple ):int{
			
			return radio_buttons_arr.indexOf( radioBtn );
		}
		/**
		 * Handles the clicks on the radio btn.
		 * @param event
		 * 
		 */		
		public function onRadioButtonClick( event:Event ):void{
			
			for( var i : uint = 0; i < radio_buttons_arr.length; i++ ) {
				var radio_btn:RadioButtonSimple = radio_buttons_arr[i];
				if( event.currentTarget == radio_buttons_arr[i] ) {
					current = i;
				}
			}
		}
		
		public function get length():uint	{
			
			return radio_buttons_arr.length;
		}
		
		public function set current( index:int ):void{
			
			current_index = index;
			dispatchEvent( new EventTrans( Event.CHANGE, current_index ) );
			markNewSelection();
		}
		
		private function markNewSelection():void {
			
			for( var i : uint = 0; i < radio_buttons_arr.length; i++ ) {
				var radio_btn : RadioButtonSimple = radio_buttons_arr[i];
				radio_btn.checked = ( i == current_index );
			}
		}
		
		public function get current():int	{
			
			return current_index;
		}
	}
}