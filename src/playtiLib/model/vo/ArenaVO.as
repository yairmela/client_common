package playtiLib.model.vo
{
	import playtiLib.utils.text.TextUtil;

	public class ArenaVO
	{
		//set by xml
		private var _id:uint;
		private var _enginePath:String;
		private var _popupOutOfMoneyName:String;
		private var _useEmbededIcons:Boolean;
		//set by arenas proxy
		private var _name:String;
		private var _arenaMC:String;
		private var _preloaderName:String;
		private var _arenaContainerName:String;
		private var _btnName:String;
		private var _folderName:String;
		private var _engineShortName:String;
		private var _singleCacheId:Boolean;
		
		public function ArenaVO(arenaXML:XML)
		{
			_id 					= uint(arenaXML.@id);
			_popupOutOfMoneyName 	= arenaXML.@popup_out_of_money;
			_useEmbededIcons 		= TextUtil.getBooleanByString(arenaXML.@use_embeded_icon);
			_folderName 			= arenaXML.@folder_name;
			_engineShortName 		= arenaXML.@engine_short_name;
			_singleCacheId			= TextUtil.getBooleanByString(arenaXML.@single_cache_id);
		}

		public function setPropertiesByName(engineNameFromServer:String):void
		{
			var arenaName:String = engineNameFromServer.toLocaleLowerCase();
			_name = arenaName + 'Arena';
			_arenaMC = engineShortName + '_arena_mc';
			_arenaContainerName = engineShortName + '_arena_con';
			_preloaderName = engineShortName + '_preloader';
			_btnName =  engineShortName + '_btn';
			_enginePath =  folderName + '/caesars_' + engineShortName + '.swf';
		}
		
		//getters
		public function get engineShortName():String{ return _engineShortName;	}
		public function get folderName():String	{ return _folderName;}
		public function get singleCacheId():Boolean	{	return _singleCacheId;	}
		public function get btnName():String{	return _btnName;	}
		public function get arenaContainerName():String	{	return _arenaContainerName;	}
		public function get preloaderName():String	{	return _preloaderName;	}
		public function get arenaMC():String{	return _arenaMC;	}
		public function get name():String{	return _name;	}
		public function get useEmbededIcons():Boolean	{	return _useEmbededIcons;	}
		public function get popupOutOfMoneyName():String{	return _popupOutOfMoneyName;	}
		public function get enginePath():String		{	return _enginePath;	}
		public function get id():uint	{	return _id;	}
	}
}