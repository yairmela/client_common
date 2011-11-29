package playtiLib.model.proxies.timer
{
	public class GameTimerProxy extends TimerProxy{
		
		public static const NAME:String = 'GameTimerProxy';
		
		public function GameTimerProxy( delay:Number ){
			
			super(NAME, delay);
		}
	}
}