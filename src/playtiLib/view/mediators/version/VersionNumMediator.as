package playtiLib.view.mediators.version
{
	import playtiLib.view.components.popups.PopupViewLogic;
	import playtiLib.view.components.version.VersionNumView;
	import playtiLib.view.mediators.popups.PopupMediator;
	
	public class VersionNumMediator extends PopupMediator{
		
		public static const NAME:String = 'VersionNumMediator';
		
		public function VersionNumMediator( version_num:String ){
			
			super( NAME, new PopupViewLogic( null, new VersionNumView( version_num ) ) );
		}
	}
}