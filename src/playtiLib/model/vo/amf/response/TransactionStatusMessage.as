package playtiLib.model.vo.amf.response
{
	import playtiLib.model.vo.payment.CurrencyCost;

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