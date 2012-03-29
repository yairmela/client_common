package playtiLib.model.vo.inventory
{
	import playtiLib.model.vo.server.DeserializedJSONModel;

	public class Product extends DeserializedJSONModel
	{
		public var id:int; 
		public var price:int; 
		public var sell_price:int;
		
		public var name:String;
		public var title:String;
		public var description:String;
		
		public var category:String;
		public var resource:String;
		public var kind:String;
		public var level:int;
		
		//public var pt_change:int;
		//public var reward_after_use_change:int;
	}
}