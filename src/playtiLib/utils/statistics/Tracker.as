package playtiLib.utils.statistics
{
	
	/**
	 * Access to the tracker singaltons and all it's functionality. All it's functions are static.
	 * All the tracking is in the appliction is from here.
	 */	
		
	public class Tracker
	{
		static private var trackers_list : Object = {};
		
//		public function Tracker() {
//		}
			
		static public function setTracker(tracker:ISpecificTracker, id:String):void {
			trackers_list[id] = tracker;
		}
		
		static public function getTracker(id:String):ISpecificTracker {
			return trackers_list[id];
		}
		
		static public function track(eventName:String, snapshot:TrackSnapshot):void {
			for each(var tracker : ISpecificTracker in trackers_list) {
				tracker.track(eventName, snapshot);
			}
		}
	}
}