package playtiLib.model.vo
{
	public class ArenaVO
	{
		public var id:uint;
		public var name:String;
		public var title:String;
		public var arenaMC:String;
		
		public function ArenaVO(arenaXML:XML)
		{
			id = uint(arenaXML.@id);
			name = arenaXML.@name;
			title = arenaXML.@title;
			arenaMC = arenaXML.@arena_mc;
		}
	}
}