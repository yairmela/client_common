package playtiLib.controller.commands.social.fb
{
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.social.SocialCallsConfig;
	import playtiLib.controller.commands.coupons.CouponCommand;
	import playtiLib.model.VO.social.SNRequestDataVO;
	import playtiLib.model.VO.social.SocialRequestsListVO;
	import playtiLib.model.proxies.social.FBRequestsProxy;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.utils.time.TimeUtil;
	
	public class FBLoadSocialRequestsCommand extends CouponCommand
	{
		override public function execute(notification:INotification):void {
			//we load the FB requests
			var dataCapsule:DataCapsule = DataCapsuleFactory.getDataCapsule( [SocialCallsConfig.APP_REQUESTS] );
			dataCapsule.addEventListener( Event.COMPLETE, onDataReady);
			dataCapsule.loadData();
		}
		
		private function onDataReady( event:Event ):void {
			
			var dataCapsule:DataCapsule = event.currentTarget as DataCapsule;
			//get the list of FB requests
			var requests:Array/*SocialRequestsVO*/ = ( dataCapsule.getDataHolderByIndex(0).data as SocialRequestsListVO ).list;
			//change the req id to id+'_'+userId
//			for each(var sn_request:SNRequestDataVO in requests){
//				//				sn_request.id = sn_request.id.slice(0,sn_request.id.indexOf("_") !=-1 ? sn_request.id.indexOf("_") : sn_request.id.length-1);
//				sn_request.id = sn_request.id+'_'+sn_request.receiver_id;
//			}
			
			//save the non valid request for removal
			var nonValidRequests:Array = requests.filter(//filter time expiration & missing token
				function ( element:SNRequestDataVO, ...args ):Boolean {
					return !isValidRequest( element );
				});
			
			//filter out the non valid requests from main list
			requests = requests.filter( isValidRequest );
			
			if( !facade.hasProxy( FBRequestsProxy.NAME ) ) {//first load in this session
				facade.registerProxy( new FBRequestsProxy( requests ) );
				for each(var req:SNRequestDataVO in nonValidRequests){
					if(req.coupon_token == 'undefined' ){
						fb_request_proxy.addNewInviteRequests([req]);
					}
				}
			} else { //if this is second time we load the fb requests
				//filter the unknown (new) requests and send only new to the get_and_validate_command
				requests = requests.filter( 
					function( element:SNRequestDataVO, ...args ):Boolean { 
						return fb_request_proxy.tokens.indexOf( element.coupon_token ) < 0;
					} );
				
				fb_request_proxy.addNewRequests(requests);
			}
			//check if fb request removal is needed
			if( nonValidRequests.length > 0 ){
				sendNotification( GeneralAppNotifications.REMOVE_APP_REQUEST, getRequstId( nonValidRequests ) );
			}
			//pass the requests tokens for "get and valid" to continue the coupons load process
			var tokens:Array = requests.map( 
				function( item:SNRequestDataVO, ...args ):String { 
					return item.coupon_token } )
			sendNotification( GeneralAppNotifications.GET_AND_VALIDATE_COUPONS, tokens );
		}
		
		private function isValidRequest( element:SNRequestDataVO, ...args ):Boolean {
			
			return !isTimeExpired( element.created_time, flashVars.serverDate, flashVars.couponsExpiredDays ) &&
				element.coupon_token && element.coupon_token != '' && element.coupon_token != 'undefined' && element.coupon_token != null;
			
		}
		
		private function isTimeExpired( fbRequestCreatedTime:String, serverDateTime:String, couponsDaysLast:int ):Boolean {
			
			var requestCreatedAt:Date = TimeUtil.buildDate(fbRequestCreatedTime) ;
			var dateOnServer:Date = TimeUtil.buildDate(serverDateTime);
			return dateOnServer.getTime() - requestCreatedAt.getTime() > couponsDaysLast*1000*60*60*24;
		}
		
		private function getRequstId( requestsArr:Array ):Array{
			return requestsArr.map( function(item:SNRequestDataVO, ...args):String { return item.id } );
		}
	}
}