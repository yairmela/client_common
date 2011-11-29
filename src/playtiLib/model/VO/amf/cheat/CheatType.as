package playtiLib.model.VO.amf.cheat
{
	public class CheatType
	{
		public static const NO_CHEAT:String = 'NO_CHEAT';
		public static const CHEAT_FREE_SPINS:String = 'CHEAT_FREE_SPINS';
		public static const CHEAT_BONUS:String = 'CHEAT_BONUS';
		public static const CHEAT_CONFIG:String = 'CHEAT_CONFIG';
		public static const CHEAT_WIN_BONUS_ROUND:String = 'CHEAT_WIN_BONUS_ROUND';
		
		public var cheat:String = NO_CHEAT;
		
		public function CheatType()
		{
		}
	}
}