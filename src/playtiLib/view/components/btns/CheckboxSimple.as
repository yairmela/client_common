package playtiLib.view.components.btns
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * An extended class to ButtonSimple. It implements the check box button idea. 
	 */	
	public class CheckboxSimple extends ButtonSimple{
		
		static public const SUFFIX_CHECKED:String   = "_checked";
		static public const SUFFIX_UNCHECKED:String = "_unchecked";
		
		protected var state_checked:Boolean;
		
		public function CheckboxSimple( content:MovieClip ):void{
			
			super( content );
			checked = false;
		}
		
		public function set checked( value:Boolean ) : void	{
			
			state_checked = value;
			updateDisplay();
		}
		
		public function get checked():Boolean{
			
			return state_checked;
		}
		/**
		 * Overrides the ButtonSimple function and adds it that stateCheck = !checked 
		 * @param event
		 * 
		 */		
		override protected function onMouseClickEvent( event:Event ):void{
			
			state_checked = !checked;
			super.onMouseClickEvent( event );
		}
		/**
		 * Overrides the ButtonSimple function. If the stateChecked == 'true', it goto
		 * the appropriate lable that checked and if it 'false' it go to the appropriate lable
		 * that wasn't checked before.
		 * 
		 */		
		override protected function updateDisplay():void{
			
			var state_name:String = ( ( checked ) ? ( SUFFIX_CHECKED ) : ( SUFFIX_UNCHECKED ) );
			content.gotoAndPlay( current_label_name + state_name );
			
			text = current_text;
		}
	}
}