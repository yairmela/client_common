package playtiLib.model.VO.amf.response.helpers 
{
	public class LocaleCommandParams 
	{
		public var techName:Array;
		public var category:int;
		
		public var lang:String;
		
		public function LocaleCommandParams(category:int, techName:Array)
		{
			this.category = category;
			this.techName = techName;
		}
	}
}