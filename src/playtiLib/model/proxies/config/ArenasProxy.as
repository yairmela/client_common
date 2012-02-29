package playtiLib.model.proxies.config
{
	import flash.events.Event;
	
	import playtiLib.model.proxies.data.XMLProxy;
	import playtiLib.model.vo.ArenaVO;
	
	public class ArenasProxy extends XMLProxy
	{
		//-----------------------------------------------------------------------------------------
		//
		// Public properties
		//
		//-----------------------------------------------------------------------------------------
		
		public static const NAME:String = 'ArenasProxy';
		
		public function get defaultArena():ArenaVO
		{
			return _defaultArena;
		}

		public function get arenas():Vector.<ArenaVO>
		{
			return _arenas;
		}
		
		//-----------------------------------------------------------------------------------------
		//
		// Private properties
		//
		//-----------------------------------------------------------------------------------------
		
		private var _arenas:Vector.<ArenaVO>; 
		private var _defaultArena:ArenaVO; 
		

		//-----------------------------------------------------------------------------------------
		//
		// Constructor
		//
		//-----------------------------------------------------------------------------------------

		
		public function ArenasProxy(xml_path:String=null)
		{
			super(NAME, xml_path);
		}
		
		//-----------------------------------------------------------------------------------------
		//
		// Private methods
		//
		//-----------------------------------------------------------------------------------------
		
		override protected function loadCompleteHandler(event:Event):void 
		{
			super.loadCompleteHandler(event);
			
			_arenas = parseArenas();
			_defaultArena = getDefaultArena();
		}
		
		private function parseArenas():Vector.<ArenaVO>
		{
			var arenasXMLList:XMLList = data.main_lobby.arena;
			var result:Vector.<ArenaVO> = new Vector.<ArenaVO>();
			
			for each (var arenaXML:XML in arenasXMLList) 
			{
				var arenaVO:ArenaVO = new ArenaVO(arenaXML);
				result.push(arenaVO);
			}
			
			return result;
		}
		
		private function getDefaultArena():ArenaVO
		{
			var defaultArenaID:uint = uint(data.children()[0].@default_arena);
			
			for (var i:uint=0; i<arenas.length; i++)
			{
				if (arenas[i].id == defaultArenaID)
				{
					return arenas[i];
				}
			}
			return null;
		}
	}
}