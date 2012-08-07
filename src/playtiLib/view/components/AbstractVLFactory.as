package playtiLib.view.components
{
	import flash.display.MovieClip;
	
	import playtiLib.utils.warehouse.GraphicsWarehouseList;
	import playtiLib.view.interfaces.IViewLogic;

	
	public class AbstractVLFactory
	{
		protected static function getAsset(assetName:String):MovieClip
		{
			return GraphicsWarehouseList.getAsset(assetName) as MovieClip;
		}		
	}
}