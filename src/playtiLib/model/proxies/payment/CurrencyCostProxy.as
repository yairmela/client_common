package playtiLib.model.proxies.payment
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.model.VO.payment.CurrencyCost;
	
	public class CurrencyCostProxy extends Proxy{
		
		public static const NAME:String = "CurrencyCostProxy";
		
		private var _selectedCost:CurrencyCost;
		private var _transactionToken:String;
		private var _transactionId:int;
		
		public function CurrencyCostProxy()	{
			
			super(NAME, null);
		}
		/**
		 * A getter function that returns the _selectedCostVO parameter
		 * @return 
		 * 
		 */		
		public function get selected_cost():CurrencyCost {
			
			return _selectedCost;
		}
		/**
		 * Set the  _selectedCostVO paramether
		 * @param value
		 * 
		 */
		public function set selected_cost( value:CurrencyCost ):void{
			
			_selectedCost = value;
		}
	
		public function get current_transaction_token():String {
			
			return _transactionToken;
		}

		public function set current_transaction_id( value:int ):void{
			
			_transactionId = value;
		}
		
		public function get current_transaction_id():int {
			
			return _transactionId;
		}
		
		public function set current_transaction_token( value:String ):void{
			
			_transactionToken = value;
		}
		/**
		 * Sets the data of this proxy to be CurrencyCostListVO
		 * @param oCurrencyCostListVO
		 * 
		 */
		public function setCurrencyCostList( currencyCostList:Array ):void{
			
			setData( currencyCostList );		
		}
		/**
		 * Returns the data as a CurrencyCostListVO
		 * @return 
		 * 
		 */		
		public function getCurrencyCostList():Array	{
			
			return (getData() as Array);
		}
	}
}