package playtiLib.model.vo.user
{
	import playtiLib.model.vo.server.DeserializedJSONModel;

	public class UserPreferences extends DeserializedJSONModel	{
		
		public var mute:Boolean;
		public var pluginGames:Array;
		
		public function UserPreferences(){
			pluginGames=[];
		}
	}
}