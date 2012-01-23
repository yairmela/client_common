package playtiLib.utils.statistics.googleAnalytics
{
	import com.google.analytics.GATracker;
	
	import flash.display.DisplayObject;
	
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.utils.statistics.ISpecificTracker;
	import playtiLib.utils.statistics.GeneralTrackSnapshot;
	
	public class GeneralGoogleAnalyticsTracker implements ISpecificTracker
	{
		static public const NAME : String = "GoogleAnalyticsTracker";

		protected var ga_tracker : GATracker;
		
		public function init(display_object:DisplayObject, account:String, mode:String='AS3', is_debug:Boolean=false):void {
			
			ga_tracker = new GATracker( display_object, account, mode, is_debug );
		}
		
		public function track(eventName:String, snapshot:*):void {

			switch(eventName) {
				case GeneralStatistics.ERROR_SYSTEM:
					trackPage(eventName+"_error_code_"+snapshot.error_code);
					break;
				
				case GeneralStatistics.ERROR_FROM_SERVER:
					trackPage(eventName+"_code_"+snapshot.error_code);
					break;
				default:
					trackPage(eventName);
					break;
			}
		}
		
		protected function trackEvent(category:String, action:String, label:String = "", num:Number = undefined):void {
			
			ga_tracker.trackEvent(category, action, label, num);
		}
		
		protected function trackPage(url:String):void {
			
			ga_tracker.trackPageview(url);
		}
	}
}