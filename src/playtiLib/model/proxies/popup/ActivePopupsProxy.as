package playtiLib.model.proxies.popup
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	import playtiLib.view.mediators.popups.PopupMediator;
	/**
	 * Handles the active popups that opened on stage.
	 * @see org.puremvc.as3.patterns.proxy.Proxy
	 * @see playtiLib.view.mediators.popups.PopupMediator
	 */	
	public class ActivePopupsProxy extends Proxy{
		
		public static const NAME:String = 'ActivePopupsProxy';
		
		public function ActivePopupsProxy()	{
			
			super( NAME, [] );
		}
		
		private function get actives():Array { return data as Array; }
		/**
		 * Adds a popupMediator to the array of active popups.  
		 * @param mediator
		 * 
		 */		
		public function addPopup( mediator:PopupMediator ):void {
			
			actives.push( mediator );
		}
		/**
		 * Remove the current popupMediator from the array of active popup 
		 * @param mediator
		 * 
		 */		
		public function removePopup( mediator:PopupMediator ):void {
			
			actives.splice(actives.indexOf( mediator ),1);
		}
		/**
		 * Return true if there is at least one active popup and false otherwise 
		 * @return 
		 * 
		 */		
		public function hasActive():Boolean { return actives.length > 0; }
	}
}