package playtiLib.model.proxies.social.fb
{
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.vo.social.SNRequestDataVO;
	import playtiLib.model.vo.social.SocialRequestsListVO;
	
	public class FBRequestsProxy extends Proxy
	{
		public static const NAME:String = "FBRequestsProxy"; 
		private var invite_request_ids:Array = new Array();
		
		public function FBRequestsProxy( requests:Array ){
			
			super( NAME, requests );
		}
		
		public function get requests():Array{
			return getData() as Array;
		}
		
		public function addNewRequests(list:Array):void {
			data = requests.concat(list);
		}
		
		public function addNewInviteRequests(list:Array):void {
			invite_request_ids = list.map(function(item:SNRequestDataVO, ...args):String { return item.id });
		}
		
		public function isInviteRequestById(request_id:String):Boolean{
			for each( var invite:String in invite_request_ids ){
				if(invite == request_id || invite.indexOf( request_id ) > -1){
					return true;
				}
			}
			return false;
		}
		
		public function get tokens():Array{
			return requests.map( function(item:SNRequestDataVO, ...args):String { return item.coupon_token } );
		}
		
		public function get request_ids():Array{
			return requests.map( function(item:SNRequestDataVO, ...args):String { return item.id } );
		}
		
		//remove the requestId from the list and send to FB call to delete that notification
		public function removeCouponRequest( token:String ):void{
			var req:SNRequestDataVO = getRequestByToken(token);
			if( req ) {
				sendNotification( GeneralAppNotifications.REMOVE_APP_REQUEST, [req.id] );
				requests.splice( requests.indexOf(req),1 );
			}
		}
		
		private function getRequestByToken( token:String ):SNRequestDataVO {
			for each( var req:SNRequestDataVO in requests ) {
				if( req.coupon_token == token )
					return req;
			}
			return null;
		}
		
		private function getRequestById( request_id:String ):SNRequestDataVO {
			for each( var req:SNRequestDataVO in requests ) {
				if( req.id == request_id )
					return req
			}
			return null;
		}
		
		public function getTokenById( request_id:String ):String {
			var req:SNRequestDataVO = getRequestById( request_id );
			return req? req.coupon_token : '';
		}
		
		public function getIdByToken( token:String ):String {
			var req:SNRequestDataVO = getRequestByToken( token );
			return req? req.id : '';
		}
	}
}