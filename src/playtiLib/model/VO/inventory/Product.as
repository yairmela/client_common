package playtiLib.model.VO.inventory
{
	import playtiLib.model.VO.server.DeserializedModel;

	public class Product extends DeserializedModel
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