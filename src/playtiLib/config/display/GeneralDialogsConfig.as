package playtiLib.config.display
{
	/**
	 * This class configures assets names as they will appear in the FLA library. 
	 * For each library usable assets that it's functionality was implemented in Playtilib we set an external name.
	 * For every new game to ensure all playtilib functionality we need to supply all assets in it's FLA.
	 */	
	public class GeneralDialogsConfig	{
		
		public static const POPUP_TRAN_NOT_ENOUGH_MONEY:String 	= 'popup_tran_not_enough_money';
		public static const POPUP_TRAN_ERROR:String 			= 'popup_transaction_error';
		public static const POPUP_SYSTEM_MSG:String 			= 'pop_up_client_msg_mc';
		public static const POPUP_GIFT_STATUS:String 			= "pop_up_gift_status_mc";
		public static const POPUP_GIFT_REDEEMED:String 			= "pop_up_gift_redeemed_mc";
		public static const POPUP_GIFT_MISSED:String 			= "pop_up_gift_missed_mc";
		public static const POPUP_COLLECT_GIFTS:String 			= 'pop_up_collect_gifts';
		public static const POPUP_GIFTS_ARE_NOT_AVAILABLE:String= 'pop_up_gcp_not_available';
	}
}