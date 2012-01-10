package playtiLib.view.components.text
{
	import fl.motion.easing.Linear;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	import playtiLib.utils.text.TextUtil;
	import playtiLib.view.interfaces.IViewLogic;
	
	public class EaseCounterText implements IViewLogic	{
		
		protected var text_con_mc:MovieClip;
		private var counter_txt:TextField;
		
		private var ease_count:int;
		private var ease_count_final:int;
		
		private var current_value:Number = 0;
		private var ease_start_value:Number;
		private var ease_delta_value:Number;
		
		private var is_thouthand_separate:Boolean;
		private var display_decimals : Boolean;
		
		public function EaseCounterText( text_con_mc:MovieClip, text_filed_name:String, ease_frame_laps:int = 40, is_thouthand_separate:Boolean = false, display_decimals : Boolean = false )	{
			
			this.text_con_mc 			= text_con_mc;
			this.counter_txt 			= text_con_mc[text_filed_name] as TextField;
			this.ease_count_final 		= ease_frame_laps;
			this.is_thouthand_separate 	= is_thouthand_separate;
			this.display_decimals 		= display_decimals;
		}
		
		public function forceValue( new_value:Number ):void {
			
			if ( new_value.toString() == Number.NaN.toString() ){
				counter_txt.text = "Connecting...";
				return;
			}
			//set new value
			current_value = new_value;
			if ( is_thouthand_separate ) {
				counter_txt.text = TextUtil.numberFormat( current_value, (display_decimals ? 2 : 0) );
			}else{
				counter_txt.text = current_value.toFixed( 2 );
			}
		}
		
		public function set value( new_value:Number ):void {
			
			if (new_value.toString() == Number.NaN.toString()){
				counter_txt.text = "Connecting...";
				return;
			}
			ease_start_value = current_value;
			ease_delta_value = new_value - current_value;
			ease_count = 0;
			text_con_mc.addEventListener( Event.ENTER_FRAME, changeValueHandler );
		}
		
		public function get value():Number {
			
			return current_value;
		}
		/**
		 * Function that handles the ENTER_FRAME event that the text_con_mc listens to. 
		 * @param event
		 * 
		 */		
		private function changeValueHandler( event:Event ):void {
			
			var next_value:Number = Linear.easeIn( ease_count, ease_start_value, ease_delta_value, ease_count_final );
			forceValue( next_value );
			if( ease_count == ease_count_final )
				text_con_mc.removeEventListener(Event.ENTER_FRAME, changeValueHandler);
			ease_count++;
		}
		/**
		 * Removes the event listener from the text_con_mc 
		 * 
		 */		
		public function stopAnim():void {
			
			//make sure to stop animation
			text_con_mc.removeEventListener( Event.ENTER_FRAME, changeValueHandler );
		}
		
		public function get content():DisplayObject{
			
			return counter_txt;
		}
	}
}