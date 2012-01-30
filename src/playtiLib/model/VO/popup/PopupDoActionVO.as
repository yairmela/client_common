package playtiLib.model.VO.popup
{
	/**
	 * Holds the popup do action data. It holds some arrays with the notification 
	 * names, body, and type order by their ids. It also holds an array of the popups that 
	 * should be closed after the do action.  
	 */	
	public class PopupDoActionVO	{
		
		public var notification_names:Array;
		public var notification_types:Array;
		public var notification_bodys:Array;
		public var notification_tracking_strings:Array;
		public var should_close_after_do:Array;
 		 
		public function PopupDoActionVO( notification_names:Array, notification_bodys:Array=null, notification_types:Array=null, notification_tracking_strings:Array=null, should_close_after_do:Array=null )	{
			
			this.notification_names = notification_names;
			this.notification_types = notification_types;
			this.notification_bodys = notification_bodys;
			this.notification_tracking_strings = notification_tracking_strings;
			this.should_close_after_do = should_close_after_do;
		}
		/**
		 * Returns the notification name with this id and null if there is no notification with this id 
		 * @param id
		 * @return 
		 * 
		 */		
		public function notificationById( id:int ):String {
			
			if( notification_names == null || id >= notification_names.length )
				return null
			return notification_names[id];
		}
		/**
		 * Returns the type of the notification with this id and null if there is no notification with this id 
		 * @param id
		 * @return 
		 * 
		 */		
		public function notificationTypeById( id:int ):String {
			
			if( notification_types == null || id >= notification_types.length )
				return null
			return notification_types[id];
		}
		/**
		 * Returns the notification object with this id parameter and null if there is no notification with this id.
		 * @param id
		 * @return 
		 * 
		 */		
		public function notificationBodyById( id:int ):Object {
			
			if( notification_bodys == null || id >= notification_bodys.length )
				return null
			return notification_bodys[id];
		}
		/**
		 * Returns the notification_tracking_strings with this id parameter and null if there is no notification with this id 
		 * @param id
		 * @return 
		 * 
		 */		
		public function notificationTrackStringById( id:int ):String {
			
			if( notification_tracking_strings == null || id >= notification_tracking_strings.length )
				return null
			return notification_tracking_strings[id];
		}
		/**
		 * Returns true if the popup with this id should be closed after do and false otherwise 
		 * @param id
		 * @return 
		 * 
		 */		
		public function closeAfterById( id:int ):Boolean {
			
			if( should_close_after_do == null || id >= should_close_after_do.length )
				return true;
			return should_close_after_do[id];
		}
		
		public function updateNotificationBodyById( id:int, value:Object ):void {
			
			if( notification_bodys == null ) {
				notification_bodys = [];
			}
			
			notification_bodys[id] = value;
		}
	}
}