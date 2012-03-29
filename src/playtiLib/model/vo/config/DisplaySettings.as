package playtiLib.model.vo.config
{
	import flash.geom.Point;

	/**
	 * Holds the display setting data like the full screen mode parameter 
	 */ 
	public class DisplaySettings{
		
		public var fullscreen : Boolean = false;
		public var fullscreenSize:Point;
		public var defaultFramerate:Number;
		public var framerate:Number;
	}
}