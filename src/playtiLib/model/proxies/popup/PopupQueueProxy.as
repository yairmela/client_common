package playtiLib.model.proxies.popup
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.view.mediators.popups.PopupMediator;
	/**
	 * Handles the popups queue that wait to add to stage
	 * @see org.puremvc.as3.patterns.proxy.Proxy
	 * @see playtiLib.view.mediators.popups.PopupMediator
	 */	
	public class PopupQueueProxy extends Proxy{
		
		public static const NAME:String = 'PopupQueueProxy';
		
		public function PopupQueueProxy(){
			
			super( NAME, [] );
		}
		
		private function get queue():Array { return data as Array; }
		/**
		 * Adds popupMediator to the queue 
		 * @param mediator
		 * 
		 */		
		public function addPopup( mediator:PopupMediator, highPriority : Boolean = false ):void {
			
			if(highPriority) {
				queue.unshift(mediator);
			}
			else {
				queue.push( mediator );
			}
		}
		/**
		 * Returns true if there is at least one popup in queue and false otherwise 
		 * @return 
		 * 
		 */		
		public function hasNext():Boolean { return queue.length > 0; }
		/**
		 * Returns the next popupMediator in the queue 
		 * @return 
		 * 
		 */		
		public function next():PopupMediator { return queue.shift() as PopupMediator; }
	}
}