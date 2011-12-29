package playtiLib.model.VO.inventory
{
	import playtiLib.model.VO.server.DeserializedJSONModel;

	public class UserItem extends DeserializedJSONModel
	{
		public var id:int;
		public var user_id:int;
		
		public var product:Product;
		public var quantity:int;
		
		public var created_at:Date;
		public var updated_at:Date;
		public var expires_on:Date;
		
		public var x:Number = 0;
		public var y:Number = 0;
		public var depth_group:int = 0;
		
		
		public function get category():String { return product.category };
		public function get description():String { return product.description };
		public function get name():String { return product.name } 
		public function get title():String { return product.title }
		public function get resource():String { return product.resource }
		public function get price():Number { return product.price }
	}
}