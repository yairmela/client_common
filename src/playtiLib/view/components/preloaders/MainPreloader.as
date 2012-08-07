package playtiLib.view.components.preloaders
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class MainPreloader extends MovieClip	{
		//if this params will not set the logic will use stage height and width
		public static var PRELOADER_CENTER_TO_WIDTH:Number;
		public static var PRELOADER_CENTER_TO_HEIGHT:Number;
		
		private var offset:Point;
		protected var progress_width:int = 200;
		protected var progress_height:int = 8;
		private var isOffsetPositionWasSet:Boolean;
		
		public function MainPreloader()	{
			
			super();
		}

		private function setOffsetPosition():void
		{
			if( !isOffsetPositionWasSet ){
				isOffsetPositionWasSet = true;
				this.offset = new Point( Math.floor( (  stage.stageWidth - progress_width ) / 2 ), 
					Math.floor( ( stage.stageHeight - progress_height ) / 2 ) );
			}
		}
		
		public function set progress( ratio:Number ):void {
			
			drawProgress( ratio );
		}
		
		protected function drawProgress(ratio:Number):void {
			setOffsetPosition();
			with( graphics ) {
				clear();
				beginFill(0x282828);
				drawRoundRect(offset.x-3,offset.y-3,progress_width+6,progress_height+6,progress_height+6,progress_height+6);
				endFill();
				lineStyle(4,0x181818);
				drawRoundRect(offset.x,offset.y,progress_width,progress_height,progress_height,progress_height);
				lineStyle(NaN);
				beginFill(0x383838);
				drawRoundRect(offset.x,offset.y,progress_width,progress_height,progress_height,progress_height);
				endFill();
				beginFill(0xffffff, .05);
				drawRoundRectComplex(offset.x,offset.y+progress_height/2,progress_width,progress_height/2,0,0,progress_height,progress_height);
				endFill();
				beginFill(0x33BEF3);
				drawRoundRect(offset.x,offset.y,progress_width*ratio,progress_height,progress_height,progress_height);
				endFill();
				beginFill(0xffffff, .25);
				drawRoundRectComplex(offset.x,offset.y,progress_width*ratio,progress_height/2,progress_height,progress_height,0,0);
				endFill();
			}
		}
	}
}