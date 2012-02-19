package playtiLib.view.mediators.popups
{
	import flash.display.Sprite;
	
	import playtiLib.model.vo.popup.PopupDoActionVO;
	import playtiLib.view.components.popups.PopupViewLogic;
	
	public class PauseLoadingGamePopupMediator extends PopupMediator{
		
		public static const NAME:String = 'PauseLoadingGamePopupMediator';
		
		public function PauseLoadingGamePopupMediator()	{
			
			super(NAME, new PopupViewLogic("pop_up_game_pause_loading"));
		}
	}
}