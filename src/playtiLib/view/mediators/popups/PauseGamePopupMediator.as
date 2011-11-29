package playtiLib.view.mediators.popups
{
	import flash.display.Sprite;
	import playtiLib.view.components.popups.PopupViewLogic;
	
	public class PauseGamePopupMediator extends PopupMediator{
		
		public static const NAME:String = 'PauseGamePopupMediator';
		
		public function PauseGamePopupMediator(){
			
			super( NAME, new PopupViewLogic( null, new Sprite ) );
		}
	}
}