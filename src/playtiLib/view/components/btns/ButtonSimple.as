package playtiLib.view.components.btns
{
	import flash.display.FrameLabel;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import playtiLib.utils.sounds.SoundsLib;
	/**
	 * Implementation of a button with all its functionality. Gets a movie clip and handles several mouse event like:
	 * MOUSE_OVER, MOUSE_OUT, MOUSE_DOWN and CLICK. It has fixed lables: BUTTON_REFERENCE_NAME,
	 * LABEL_UP, LABEL_OVER, LABEL_ROLL_OUT, LABEL_DOWN, LABEL_DIS.
	 */	
	public class ButtonSimple extends EventDispatcher{
		
		static protected const BUTTON_REFERENCE_NAME:String = "attachedButton";
		static protected const LABEL_UP:String  	 		= "up";
		static protected const LABEL_OVER:String 			= "over";
		static protected const LABEL_ROLL_OUT:String 		= "roll";
		static protected const LABEL_DOWN:String 			= "down";
		static protected const LABEL_DIS:String  			= "dis";
		
		protected var visual_content:MovieClip;
		
		protected var enable:Boolean;
		
		protected var current_label_name:String;
		protected var current_text:String;
		
		protected var additional_data:Object;
		
		private var mouse_out_lable_name:String 				= LABEL_UP;
		
		private var over_sound_name:String;
		private var click_sound_name:String;
		
		public function ButtonSimple( content:MovieClip, click_sound_name:String = null, over_sound_name:String = null ){
		
			this.click_sound_name 					= click_sound_name;
			this.over_sound_name 					= over_sound_name;
			visual_content 							= content;
			enable 									= true;
			
			visual_content[BUTTON_REFERENCE_NAME] 	= this;
			
			current_label_name 						= LABEL_UP;
			mouse_out_lable_name 						= hasLable( LABEL_ROLL_OUT ) ? LABEL_ROLL_OUT : LABEL_UP;
			
			var text_field:TextField 				= content.getChildByName("text") as TextField;
			
			if( text_field ) {
				current_text = text_field.text;
			}
			else {
				current_text = "";
			}
			
			updateDisplay();
			
			var hit_zone : InteractiveObject = getHitZone();
			
			hit_zone.addEventListener( MouseEvent.MOUSE_OVER, onMouseOverEvent );
			hit_zone.addEventListener( MouseEvent.MOUSE_OUT, onMouseOutEvent );
			hit_zone.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDownEvent );
			hit_zone.addEventListener( MouseEvent.CLICK, onMouseClickEvent );
			
			if( hit_zone == content ){
				content.mouseChildren 	= false;
				content.buttonMode 		= true;
				content.useHandCursor 	= true;
			}
		}
		
		static public function getAttachedControl( movie:MovieClip ):ButtonSimple{
			
			return ( movie[BUTTON_REFERENCE_NAME] as ButtonSimple );
		}
		
		public function set text( value:String ):void{
			
			var text_field:TextField = content.getChildByName( "text" ) as TextField;
			
			current_text = value;
			
			if( text_field ) {
				text_field.text 		 = value;
				text_field.selectable = false;
				//TODO: approve delitation
				//Auxx.setText(textField, value);
			}
		}
		
		public function get text():String{
			
			return current_text;
		}
		
		public function set data( value:Object ):void{
			
			additional_data = value;
		}
		
		public function get data():Object{
			
			return additional_data;
		}
		/**
		 * Sets the enable variable. If value is true, it also update the state
		 * to lable = 'up' and if not it update the state to lable = 'dis'. 
		 * It also set the mouseChildren to value.
		 * @param value
		 * 
		 */		
		public function set enabled( value:Boolean ):void{
			
			enable = value;
			if( value ) {
				updateState( LABEL_UP );
			}
			else {
				updateState( LABEL_DIS );
			}
			var hit_zone:InteractiveObject = getHitZone();			
			hit_zone.mouseEnabled = value;
			if( hit_zone == content )
				content.mouseChildren = value;
		}
		
		public function get enabled():Boolean{
			
			return enable;
		}
		
		public function get content():MovieClip{
			
			return visual_content;
		}
		/**
		 * Handles the mouse event - MOUSE_OVER. 
		 * @param event
		 * 
		 */	
		protected function onMouseOverEvent( event:Event ):void{
						
			updateState( LABEL_OVER );
			redispatchEvent( event );
			if( over_sound_name )
				SoundsLib.lib.playSound( over_sound_name );
		}
		/**
		 * Handles the mouse event - MOUSE_OUT. 
		 * @param event
		 * 
		 */		
		protected function onMouseOutEvent( event:Event ):void{
			
			if ( enabled ){
				updateState( mouse_out_lable_name );
				redispatchEvent( event );
			}
		}
		/**
		 * Function that handles the mouse event - MOUSE_DOWN. 
		 * @param event
		 * 
		 */		
		protected function onMouseDownEvent( event:Event ):void	{
			
			updateState( LABEL_DOWN );
			redispatchEvent( event );
		}
		/**
		 * Function that handles the mouse event - CLICK. 
		 * @param event
		 * 
		 */		
		protected function onMouseClickEvent( event:Event ):void{
			
			updateState( LABEL_OVER );
			redispatchEvent( event );
			
			if( click_sound_name )
				SoundsLib.lib.playSound( click_sound_name );
		}
		/**
		 * Updates the state of the button. If value == true, it updates the state to be
		 * lable = 'down' and if value == false, lable = 'up'. 
		 * @param value
		 * 
		 */		
		protected function updateSelectState( value:Boolean ):void{
			
			if( value ) {
				updateState( LABEL_DOWN );
			}
			else {
				updateState( LABEL_UP );
			}
		}
		
		protected function redispatchEvent( event:Event ):void{
			
			dispatchEvent( event.clone() );
			
			event.stopImmediatePropagation();
			//TODO: can we delete this junk?
			/*dispatchEvent( new MouseEvent(event.type, event.bubbles, event.cancelable, event.localX, event.localY,
			event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta,
			false, event.ctrlKey, 0) );*/
		}
		
		protected function getHitZone():InteractiveObject{
			
			var hit_zone:InteractiveObject;
			if( content.hasOwnProperty( "hit" ) ) {
				hit_zone = content["hit"] as InteractiveObject;
			}else
				hit_zone = content;
			
			return hit_zone;
		}
		/**
		 * Update the currentLableName variable to be stateName. If it is the same name,
		 * it does nothing and if it is not, it play the lable with the stateName.
		 * @param stateName
		 * 
		 */		
		protected function updateState( stateName:String ):void{
			
			if( current_label_name == stateName ) {
				return;
			}
			
			current_label_name = stateName;
			
			updateDisplay();
		}
		/**
		 * Plays the current lable. 
		 * 
		 */		
		protected function updateDisplay():void{
			
			content.gotoAndPlay( current_label_name );
			
			text = current_text;
		}
		/**
		 * Returns true if there is a lable with this name (lable_name) to the button's m.c
		 * and false if not. 
		 * @param lable_name
		 * @return 
		 * 
		 */		
		protected function hasLable( lable_name:String ):Boolean {
			
			for each( var label:FrameLabel in content.currentLabels ) {
				if( lable_name == label.name )
					return true;
			}
			return false;
		}
		
	}
}