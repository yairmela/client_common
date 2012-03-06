package playtiLib.model.vo
{
	import playtiLib.utils.text.TextUtil;

	public class ArenaVO
	{
		//set by xml
		private var _id:uint;
		private var _enginePath:String;
		private var _numberGamesInRoom:int;
		private var _popupOutOfMoneyName:String;
		private var _useEmbededIcons:Boolean;
		//set by arenas proxy
		private var _name:String;
		private var _arenaMC:String;
		private var _preloaderName:String;
		private var _arenaContainerName:String;
		private var _btnName:String;
		private var _assetCachedId:String;
		private var _folderName:String;
		private var _smallEngineIcone:String;
		
		public function ArenaVO(arenaXML:XML)
		{
			_id 					= uint(arenaXML.@id);
			_enginePath 			= arenaXML.@engine_path;
			_numberGamesInRoom 	= parseInt( arenaXML.@number_games_in_room );
			_popupOutOfMoneyName = arenaXML.@popup_out_of_money;
			_useEmbededIcons 	= TextUtil.getBooleanByString(arenaXML.@use_embeded_icon);
			_folderName 			= arenaXML.@folder_name;
			_smallEngineIcone 	= arenaXML.@small_engine_icone;
		}

		public function setPropertiesByName(engineNameFromServer:String):void
		{
			var arenaName:String = engineNameFromServer.toLocaleLowerCase();
			this._name = arenaName + 'Arena';
			this._arenaMC = smallEngineIcone + '_arena_mc';
			this._arenaContainerName = smallEngineIcone + '_arena_con';
			this._preloaderName = smallEngineIcone + '_preloader';
			this._assetCachedId = 'cached_' + this.id;
			this._btnName =  smallEngineIcone + '_btn';
		}
		
		//getters
		public function get smallEngineIcone():String{ return _smallEngineIcone;	}
		public function get folderName():String	{ return _folderName;}
		public function get assetCachedId():String	{	return _assetCachedId;	}
		public function get btnName():String{	return _btnName;	}
		public function get arenaContainerName():String	{	return _arenaContainerName;	}
		public function get preloaderName():String	{	return _preloaderName;	}
		public function get arenaMC():String{	return _arenaMC;	}
		public function get name():String{	return _name;	}
		public function get useEmbededIcons():Boolean	{	return _useEmbededIcons;	}
		public function get popupOutOfMoneyName():String{	return _popupOutOfMoneyName;	}
		public function get numberGamesInRoom():int	{	return _numberGamesInRoom;	}
		public function get enginePath():String		{	return _enginePath;	}
		public function get id():uint	{	return _id;	}
	}
}