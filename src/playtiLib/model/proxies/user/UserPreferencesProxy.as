package playtiLib.model.proxies.user
{
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.vo.user.UserPreferences;
	import playtiLib.model.proxies.data.SharedObjectProxy;
	import playtiLib.utils.core.ObjectUtil;
	
	public class UserPreferencesProxy extends SharedObjectProxy
	{
		public static const NAME:String = 'UserPreferencesProxy';
		public static const TRUE:String = 'true';
		private var viewerId:String;
		private var userPreferences:UserPreferences ;
		
		public function UserPreferencesProxy( viewerId:String )	{
			
			super(NAME);
			this.viewerId = viewerId;
			userPreferences = new UserPreferences();
			shared.data[viewerId] = shared.data[viewerId] ? shared.data[viewerId] : new UserPreferences();
			userPreferences.buildVO( shared.data[viewerId] );
		}
		
		override public function onRegister():void{
			initPreferences();
		}
		
		public function initPreferences():void{
			sendNotification( GeneralAppNotifications.MUTE_SOUNDS, userPreferences.mute );
		}
		
		public function setProperties( params:Object, ...args ):void{
			
			setRequestPropertiesByObject(params);
			
			for each( params in args) {
				setRequestPropertiesByObject(params);
			}
			save();
		}
		
		private function setRequestPropertiesByObject( params:Object ):void {
			
			var vo_properties:Array = ObjectUtil.getPropertiesType( userPreferences );
			for each( var property_info:Object in vo_properties ) {
				var key:String = property_info.name;
				
				if( params.hasOwnProperty( key ) ) {
					shared.data[viewerId][key] = params[key];
				}
			}
			getUserPreferences();
		}
		
		public function getUserPreferences():UserPreferences{
			
			userPreferences.buildVO( shared.data[viewerId] );
			return userPreferences;
		}
	}
}