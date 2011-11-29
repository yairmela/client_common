package playtiLib.view.components.list
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import playtiLib.view.components.btns.ButtonSimple;
	import playtiLib.view.components.btns.SliderSimple;
	/**
	 * A class of a simple silder. Holds 2 simple btns, timer and some more variables. 
	 */	
	public class ScrollSimple extends SliderSimple	{
		
		static private const DEFAULT_DELTA : Number 	= 0.1;
		
		static protected const SLIDER_NAME : String     = "btnSlider";
		static protected const TRACK_NAME : String      = "track";
		static protected const BUTTON_INC_NAME : String = "btnInc";
		static protected const BUTTON_DEC_NAME : String = "btnDec";
		
		static private const REITERATION_DELAY : uint 	= 100;
		protected var reiteration_timer : Timer;
		protected var btn_inc : ButtonSimple;
		protected var btn_dec : ButtonSimple;
		
		protected var current_delta : Number;
		protected var hide_disabled : Boolean;
		
		public function ScrollSimple( content : MovieClip )	{
			
			super( content );
			
			var delay : uint = getFieldSafe( "delay", REITERATION_DELAY );
			
			reiteration_timer = new Timer( delay );
			reiteration_timer.addEventListener( TimerEvent.TIMER, onReiterationTimer );
			
			btn_inc = new ButtonSimple ( MovieClip( content.getChildByName( BUTTON_INC_NAME ) ) ); 
			btn_dec = new ButtonSimple ( MovieClip( content.getChildByName( BUTTON_DEC_NAME ) ) );
			current_delta =  DEFAULT_DELTA;
			hide_disabled = getFieldSafe( "hideDisabled", false );
			
			btn_inc.addEventListener( MouseEvent.CLICK, onIncBtnClick );
			btn_dec.addEventListener( MouseEvent.CLICK, onDecBtnClick );
		}
		/**
		 * Function that handles the timer event. 
		 * @param event
		 * 
		 */		
		protected function onReiterationTimer( event : TimerEvent ) : void	{
			
			redispatchEvent( event );
		}
		/**
		 * Function that in addition to it's parent functionality, remove listeners from the two
		 * btns it holds. 
		 * @param removeContentFromStage
		 * 
		 */		
		override public function Destroy( removeContentFromStage : Boolean = true ) : void	{
			//TODO:delete junk from the code
			btn_inc.removeEventListener( MouseEvent.CLICK, onIncBtnClick );
		//	btnInc.Destroy(removeContentFromStage);
			btn_dec.removeEventListener( MouseEvent.CLICK, onDecBtnClick );
			//btnDec.Destroy(removeContentFromStage);
			super.Destroy(removeContentFromStage);
		}
		
		override public function set enabled( value : Boolean ) : void{
			
			//enabled = value;
			btn_dec.enabled 				= value;
			btn_inc.enabled 				= value;
			track.visible 				= value;
			
			slider_btn.content.visible 	= value;
			
			content.visible 			= ( hide_disabled ) ? ( value ) : ( true );
		}
		
		public function set delta( percent : Number ) : void{
			
			current_delta = percent;
		}
		
		public function get delta() : Number{
			
			return current_delta;
		}
		/**
		 * Function that handles the btnInc MOUSE_CLICK event
		 * @param event
		 * 
		 */		
		protected function onIncBtnClick( event : Event ) : void{
			
			value = value + current_delta;
			redispatchEvent( event );
		}
		/**
		 * Function that handles the btnDec MOUSE_CLICK event
		 * @param event
		 * 
		 */		
		protected function onDecBtnClick( event : Event ) : void{
			
			value = value - current_delta;
			redispatchEvent( event );
		}
		/**
		 * Function that in addition to it's parent functionality, sets the enable parameter of 
		 * it's two btns. 
		 * @param coord
		 * 
		 */		
		override protected function setSliderButtonPosition( coord : Point ) : void{
			
			super.setSliderButtonPosition( coord );
			
			btn_dec.enabled = ( coord[target_variable_name] > 0 );
			btn_inc.enabled = ( coord[target_variable_name] < track[target_range_name] );
		}
	}
}