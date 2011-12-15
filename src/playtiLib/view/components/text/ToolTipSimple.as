package playtiLib.view.components.text
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import playtiLib.utils.display.DisplayObjectUtil;
	import playtiLib.view.components.UISimple;
	/**
	 * The basic toltip. Listens to some mouse events(ROLL_OVER, MOUSE_DOWN, MOUSE_OUT, ROLL_OUT) and handles it's behavior. 
	 * Has the ability to set it's text. Can be in HIDE or SHOW mode.
	 */	
	public class ToolTipSimple extends UISimple	{
		
		static private const HIDE:String = "hide" 
		static private const SHOW:String = "show" 
		
		private var origin_parent:DisplayObjectContainer;
		private var origin_target_pos:Point;
		
		private var root_view:DisplayObject;
		private var template_texts:Object = {};
		
		//array of replace texts key=>value
		private var new_texts:Object = {};		
		
		public function ToolTipSimple( master_mc:DisplayObject, tool_tip_mc:MovieClip )	{
			
			super( tool_tip_mc );
			
			origin_parent = tool_tip_mc.parent;//will host the tooltip when it is visible false
			origin_target_pos = new Point( tool_tip_mc.x, tool_tip_mc.y );
			
			origin_parent.removeChild( tool_tip_mc );
			root_view = master_mc.stage;
			
			master_mc.addEventListener( Event.ADDED_TO_STAGE, onAddToStage, false, 0, true );
			master_mc.addEventListener( MouseEvent.ROLL_OVER, onMasterRollEvent, false, 0, true );
			master_mc.addEventListener( MouseEvent.MOUSE_DOWN, onMasterRollEvent, false, 0, true );
	//		master_mc.addEventListener (MouseEvent.MOUSE_OUT, onMasterRollEvent, false, 0, true );
			master_mc.addEventListener( MouseEvent.ROLL_OUT, onMasterRollEvent, false, 0, true );
			
		}
		/**
		 * Sets new text to it's texts fields. Gets the fields key and the text that should be inside. 
		 * @param key
		 * @param value
		 * 
		 */		
		public function setPropertyToText( key:String, value:String ):void {
			
			new_texts[key] = value;
			updateTexts();
		}
		/**
		 * Handles the add to stage event.   
		 * @param event
		 * 
		 */		
		private function onAddToStage( event:Event ):void{
			
			event.target.removeEventListener( Event.ADDED_TO_STAGE, onAddToStage );
			//save stage to root_view
			root_view = (event.target as DisplayObject).stage;
		}
		/**
		 * Runs over all the text fields and update them. 
		 * 
		 */		
		protected function updateTexts():void {
			
			//todo go over all the text
			var textFiledsDic:Dictionary = DisplayObjectUtil.getAllInstancesFromType( content as MovieClip, TextField );
			for ( var dic_key:String in textFiledsDic ) {
				var txt_field:TextField = ( content as MovieClip ).getChildByName( ( textFiledsDic[dic_key] as TextField ).name ) as TextField;
				
				if( !template_texts.hasOwnProperty(dic_key) ) {
					template_texts[dic_key] = txt_field.text;
				}
				
				var updated_text : String = template_texts[dic_key];
				for ( var key:String in new_texts ){
					updated_text = updated_text.replace( key, new_texts[key] );
				}
				txt_field.text = updated_text;
			}
		}
		protected function resetTextTemplates():void {
			
			template_texts = [];
		}
		/**
		 * Removes the tooltip from stage 
		 * 
		 */		
		private function removeFromStage():void{
			
			try{
				( root_view as Stage ).removeChild( content );
			}catch( e:Error ){
			}
		}
		/**
		 * Handles the mouseEvents. Sets position, hide, show, sets the mouseEnable and the mouseChildren. 
		 * @param event
		 * 
		 */		
		private function onMasterRollEvent( event:MouseEvent ):void {
			
			if ( event!=null && event.type == MouseEvent.ROLL_OVER ){
				contentMovie.removeEventListener( Event.ENTER_FRAME, HideHandler );
				removeFromStage();
				contentMovie.gotoAndStop( SHOW );
				updateTexts();
				//set absolut position
				var pos:Point = new Point( origin_target_pos.x, origin_target_pos.y );
				pos = origin_parent.localToGlobal( pos );
				content.x = pos.x;
				content.y = pos.y;
				//add to stage
				contentMovie.mouseEnabled = false;
				contentMovie.mouseChildren = false;
				( root_view as Stage ).addChildAt( content, ( root_view as Stage ).numChildren );
				//show tooltip
				contentMovie.gotoAndPlay( SHOW );
				
			}else{
				contentMovie.addEventListener( Event.ENTER_FRAME, HideHandler );
				contentMovie.gotoAndPlay( HIDE );
				
				resetTextTemplates();
			}
		}
		
		private function HideHandler( e:Event ):void {
			
			if ( ( content as MovieClip ).currentFrame == ( content as MovieClip ).totalFrames ){
				contentMovie.removeEventListener( Event.ENTER_FRAME, HideHandler );
				removeFromStage();
			}
		}
		
		protected function get contentMovie() : MovieClip
		{
			return ( content as MovieClip );
		}
	}
}