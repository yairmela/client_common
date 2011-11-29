package playtiLib.utils.tracing
{
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * Used for log some actions in the system.
	 */	
	public class Logger{
		
		public static var enabled:Boolean = true; 
		private static var screen_tracker_txt:TextField;
		//will swap tracker depth until this height
		private static var propagate_to_depth:int;
		
		public static function setScreenLogTracker( root:Sprite, propagate_to_depth:int ):void	{
			
			Logger.propagate_to_depth 	= propagate_to_depth;
			var screen_porp:Point 		= new Point( 600, 400 );
			var tracker_con:Sprite 		= new Sprite();
			root.stage.addEventListener( MouseEvent.MOUSE_WHEEL, scrollScreenTracker );
			tracker_con.mouseEnabled 	= false;
			tracker_con.mouseChildren 	= false;
			var padding:int 			= 5;
			with( tracker_con.graphics ) {
				beginFill( 0xffffff, .5 );
				drawRect( padding, padding, screen_porp.x, screen_porp.y );
				endFill();
			}
			screen_tracker_txt 				= new TextField;
			screen_tracker_txt.selectable 	= false
			screen_tracker_txt.mouseEnabled = false
			screen_tracker_txt.wordWrap 	= true;
			var format:TextFormat 			= new TextFormat();
			format.font 					= "Verdana";
			format.color 					= 0xa0a0a0a;
			format.size 					= 13;
			format.underline 				= true;
			screen_tracker_txt.defaultTextFormat = format;
			screen_tracker_txt.x 			= 10;
			screen_tracker_txt.y 			= 10;
			screen_tracker_txt.width 		= screen_porp.x;
			screen_tracker_txt.height 		= screen_porp.y;
			tracker_con.addChild( screen_tracker_txt )
			root.addChild( tracker_con );
		}
		/**
		 * A static function that used to log some action like:  xml ready, dialogs, login's actions,
		 * chips's actions, application's actions, errors and more. It attaches the current date and 
		 * relevant information about the action it need to log.
		 * @param str
		 * 
		 */		
		public static function log( str:String ):void{
			
			if( !enabled )
				return;
			
			var cur_date : Date = new Date();
			var time_str:String = cur_date.getMinutes() + ":" +  cur_date.getSeconds() 
									+ ":" + cur_date.getMilliseconds();
			
			if( screen_tracker_txt ) {
				screen_tracker_txt.appendText( str + "\n" );
				screen_tracker_txt.scrollV += 1;
				
				var tracker_con:Sprite = screen_tracker_txt.parent as Sprite;
				if( tracker_con.parent.numChildren > 1 && tracker_con.parent.getChildIndex( tracker_con ) < Logger.propagate_to_depth )
					tracker_con.parent.swapChildren( tracker_con, tracker_con.parent.getChildAt( tracker_con.parent.numChildren-1 ) );
				screen_tracker_txt.scrollV = screen_tracker_txt.maxScrollV
			}
		}
		
		private static function scrollScreenTracker( event:MouseEvent ):void {
			
			if( !screen_tracker_txt ) {
				return;
			}
			screen_tracker_txt.scrollV += event.delta;
		}
	}
}