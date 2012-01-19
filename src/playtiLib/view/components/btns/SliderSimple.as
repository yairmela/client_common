package playtiLib.view.components.btns {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import playtiLib.view.components.btns.ButtonSimple;
	
	/**
	 * A class of a simple btn slider. It listens to mouse events and handles them and can set it's
	 * position coordination.
	 */
	public class SliderSimple extends EventDispatcher {
		
		static public const VERTICAL:String = "vertical";
		static public const HORIZONTAL:String = "horizontal";
		
		static protected const SLIDER_NAME:String = "btnSlider";
		static protected const TRACK_NAME:String = "track";
		
		protected var stateEnabled:Boolean;
		protected var slider_btn:ButtonSimple;
		protected var track:DisplayObject;
		protected var visual_content:MovieClip;
		protected var target_variable_name:String;
		protected var target_range_name:String;
		
		protected var prev_value:Number;
		
		public function SliderSimple(content:MovieClip){
			
			visual_content = content;
			
			if (visual_content.width > visual_content.height){
				var a:String = HORIZONTAL;
				target_variable_name = "x";
				target_range_name = "width";
			} else {
				target_variable_name = "y";
				target_range_name = "height";
				a = VERTICAL;
			}
			//TODO: can we delete this junk?
			/*if(getFieldSafe("direction", VERTICAL) == VERTICAL) {
			}
			else {
			}*/
			var aBtn:Array = new Array();
			aBtn[0] = content.getChildByName(SLIDER_NAME);
			slider_btn = new ButtonSimple(aBtn[0]);
			slider_btn.addEventListener(MouseEvent.MOUSE_DOWN, onSliderButtonDownEvent);
			
			track = content.getChildByName(TRACK_NAME);
			
			track.addEventListener(MouseEvent.CLICK, onTrackDownEvent);
		}
		
		public function get content():DisplayObjectContainer {
			
			return visual_content;
		}
		
		static public function getFieldSafe(obj:Object, field:*, defaultValue:* = null):* {
			
			var result:Object;
			try {
				if (obj.hasOwnProperty(field)){
					result = obj[field];
				} else {
					result = defaultValue;
				}
			} catch (error:Error){
				result = defaultValue;
			}
			
			return result;
		}
		
		protected function redispatchEvent(event:Event):void {
			
			dispatchEvent(event.clone());
			event.stopImmediatePropagation();
			//TODO: can we delete this junk????
			/*dispatchEvent( new MouseEvent(event.type, event.bubbles, event.cancelable, event.localX, event.localY,
			event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta,
			false, event.ctrlKey, 0) );*/
		}
		
		/**
		 * Removes slider btn and track event listiners ( MOUSE_DOWN )
		 * @param removeContentFromStage
		 *
		 */
		public function Destroy(removeContentFromStage:Boolean = true):void {
			
			slider_btn.removeEventListener(MouseEvent.MOUSE_DOWN, onSliderButtonDownEvent);
			track.removeEventListener(MouseEvent.MOUSE_DOWN, onTrackDownEvent);
			//TODO: delete junk
			//sliderBtn.Destroy(removeContentFromStage);
			//super.Destroy(removeContentFromStage);			
		}
		
		public function get direction():String {
			
			if (target_range_name == "height"){
				return VERTICAL;
			} else {
				return HORIZONTAL;
			}
		}
		
		public function set enabled(value:Boolean):void {
			
			stateEnabled = value;
			
			visual_content.mouseEnabled = value;
			visual_content.mouseChildren = value;
			//TODO: delete junk
			if (stateEnabled){
				//processEventsQueue();
			}
		}
		
		public function get enabled():Boolean {
			
			return stateEnabled;
		}
		
		public function set value(percent:Number):void {
			
			var point:Point = new Point(0, 0);
			
			point[target_variable_name] = ( track[target_range_name]- slider_btn.content[target_range_name] ) * percent;
			
			setSliderButtonPosition(point);
		}
		
		public function get value():Number {
			
			return slider_btn.content[target_variable_name] / (track[target_range_name]-slider_btn.content.height);
		}
		
		/**
		 * Handles the track MOUSE_DOWN events.
		 * @param event
		 *
		 */
		protected function onTrackDownEvent(event:MouseEvent):void {
			var y:Number = event.localY * ( ( ( event as Event ).currentTarget ) as SimpleButton ).scaleY
			setSliderBtnPositionAfterTrackClick(new Point(event.localX, y));
			redispatchEvent(event);
		}
		
		/**
		 * Handles the slider btn MOUSE_DOWN events.
		 * @param event
		 *
		 */
		protected function onSliderButtonDownEvent(event:MouseEvent):void {
			
			content.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUpEvent);
			content.stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMoveEvent);
		}
		
		/**
		 * Handles the MOUSE_UP event.
		 * @param event
		 *
		 */
		protected function onStageMouseUpEvent(event:MouseEvent):void {
			
			content.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUpEvent);
			content.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMoveEvent);
			redispatchEvent(event);
		}
		
		/**
		 * Handles the MOUSE_MOVE event.
		 * @param event
		 *
		 */
		protected function onStageMouseMoveEvent(event:MouseEvent):void {
			
			var event_point:Point = new Point(event.stageX, event.stageY);
			var track_position:Point = content.localToGlobal(new Point(track.x, track.y));
			setSliderButtonPosition(event_point.subtract(track_position));
			redispatchEvent(event);
		}
		
		/**
		 * Sets the slider btn position.
		 * @param coord
		 *
		 */
		protected function setSliderButtonPosition(coord:Point):void {
			
			if (coord[target_variable_name] < 0){
				slider_btn.content[target_variable_name] = 0;
			} else if (coord[target_variable_name] > (track[target_range_name] - slider_btn.content[target_range_name]) ){
				slider_btn.content[target_variable_name] = track[target_range_name] - slider_btn.content[target_range_name];
			} else {
				slider_btn.content[target_variable_name] = coord[target_variable_name];
			}
		}
		
		private function setSliderBtnPositionAfterTrackClick(coord:Point):void{
			if( coord[target_variable_name] <  slider_btn.content[target_variable_name] ){
				slider_btn.content[target_variable_name] -= 10;
			}else{
				slider_btn.content[target_variable_name] +=10;
			}
			slider_btn.content[target_variable_name] = slider_btn.content[target_variable_name] < 0 ? 0 : slider_btn.content[target_variable_name];
			slider_btn.content[target_variable_name] = slider_btn.content[target_variable_name] > track[target_range_name] - slider_btn.content[target_range_name] ? track[target_range_name] - slider_btn.content[target_range_name] : slider_btn.content[target_variable_name];
		}
	}
}