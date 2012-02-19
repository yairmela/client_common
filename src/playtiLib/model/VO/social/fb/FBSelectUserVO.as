package playtiLib.model.vo.social.fb
{
	import playtiLib.model.vo.server.DeserializedJSONModel;
	
	public class FBSelectUserVO extends DeserializedJSONModel 
	{
		public var id:String;
		public var name:String;
		public var position:int = -1;
		
		public function FBSelectUserVO(){
		}
	}
}