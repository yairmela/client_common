package playtiLib.model.vo
{
	import playtiLib.utils.text.TextUtil;

	public class ArenaVO
	{
		//set by xml
		public var id:uint;
		public var enginePath:String;
		public var numberGamesInRoom:int;
		public var popupOutOfMoneyName:String;
		public var useEmbededIcons:Boolean;
		//set by arenas proxy
		public var name:String;
		public var arenaMC:String;
		public var preloaderName:String;
		public var arenaContainerName:String;
		public var btnName:String;
		public var assetCachedId:String;
		public var folderName:String;
		public var smallEngineIcone:String;
		
		
		public function ArenaVO(arenaXML:XML)
		{
			id 					= uint(arenaXML.@id);
			enginePath 			= arenaXML.@engine_path;
			numberGamesInRoom 	= parseInt( arenaXML.@number_games_in_room );
			popupOutOfMoneyName = arenaXML.@popup_out_of_money;
			folderName 			= arenaXML.@folder_name;
			smallEngineIcone 	= arenaXML.@small_engine_icone;
			useEmbededIcons 	= TextUtil.getBooleanByString(arenaXML.@use_embeded_icon);
			
		}
	}
}