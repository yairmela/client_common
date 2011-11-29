package playtiLib.model.VO.amf.response
{
	import playtiLib.model.VO.payment.CurrencyCost;

	public class TransactionStatusMessage extends ResultMessage
	{
		public var transactionToken : String;
		public var transactionStatus : String;
		public var transactionInfo : CurrencyCost;
		
		public function TransactionStatusMessage()
		{
		}
	}
}