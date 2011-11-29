package playtiLib.view.components.btns
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * An extended class to CheckboxSimple with a little change on the handles with the mouse click
	 * event.
	 */	
	public class RadioButtonSimple extends CheckboxSimple{
		
		public function RadioButtonSimple( content:MovieClip ){
			
			super( content );
		}
		/**
		 * An overriden function that does: if check variable is false, the function does what
		 * it's parent does and if it is true, it update the state to be LABLE_OVER 
		 * @param event
		 * 
		 */		
		override protected function onMouseClickEvent( event:Event ):void{
			
			if( !checked ) {
				super.onMouseClickEvent( event );
			}
			else 
				updateState( LABEL_OVER );
		}
	}
}