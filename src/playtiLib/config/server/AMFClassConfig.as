package playtiLib.config.server
{	
	import flash.net.registerClassAlias;
	
	import mx.collections.ArrayCollection;
	import mx.messaging.config.ConfigMap;
	import mx.messaging.messages.*;
	import mx.rpc.*;
	import mx.utils.ObjectProxy;
	
	import playtiLib.model.VO.amf.request.*;
	import playtiLib.model.VO.amf.response.*;
	import playtiLib.model.VO.amf.response.helpers.*;
	import playtiLib.model.VO.payment.CurrencyCost;

	public class AMFClassConfig	{
		
		public static function registerClasses():void {
			
			registerClassAlias( "flex.messaging.messages.ErrorMessage", ErrorMessage );
			registerClassAlias( "flex.messaging.messages.CommandMessage", CommandMessage );
			registerClassAlias( "flex.messaging.messages.RemotingMessage", RemotingMessage );
			registerClassAlias( "flex.messaging.messages.AcknowledgeMessage", AcknowledgeMessage );
			registerClassAlias( "DSC", CommandMessageExt );
			registerClassAlias( "DSK", AcknowledgeMessageExt );
			registerClassAlias( "flex.messaging.config.ConfigMap", ConfigMap );
			registerClassAlias( "flex.messaging.io.ArrayCollection", ArrayCollection );
			registerClassAlias( "flex.messaging.io.ObjectProxy", ObjectProxy );
			
			registerClassAlias( "com.playtika.casino.common.messages.requests.ClientRequest", ClientRequest );
			registerClassAlias( "com.playtika.casino.common.messages.SessionInfo", SessionInfo );
			registerClassAlias( "com.playtika.casino.messages.request.LoginRequest", LoginRequest );
			registerClassAlias( "com.playtika.casino.messages.request.RegisterRequest", RegisterRequest );
			registerClassAlias( "com.playtika.casino.messages.request.UpdateUserInfoRequest", UpdateUserInfoRequest );
			//coupon
			registerClassAlias( "com.playtika.casino.messages.request.CouponRequest", CouponRequest );
			registerClassAlias( "com.playtika.casino.messages.request.CreateEventCouponRequest", CreateEventCouponRequest );
			registerClassAlias( "com.playtika.casino.messages.response.CouponsListMessage", CouponsListMessage );
			registerClassAlias( "com.playtika.coupon.common.logic.Coupon", Coupon );
			registerClassAlias( "com.playtika.casino.messages.response.CouponMessage", CouponMessage );
			registerClassAlias( "com.playtika.casino.messages.response.CollectCouponMessage", CollectCouponMessage );
			registerClassAlias( "com.playtika.casino.messages.response.CouponReceiversMessage", CouponReceiversMessage );
			
			registerClassAlias( "com.playtika.casino.common.messages.responses.ClientResponse", ClientResponse );
			registerClassAlias( "com.playtika.casino.common.messages.responses.ServiceMessage", ServiceMessage );
			registerClassAlias( "com.playtika.casino.common.messages.responses.ResultMessage", ResultMessage );
			registerClassAlias( "com.playtika.casino.messages.response.LoginMessage", LoginMessage );
			registerClassAlias( "com.playtika.casino.messages.response.RegisterMessage", RegisterMessage );
			//user
			registerClassAlias( "com.playtika.casino.common.messages.UserInfoMessage", UserInfoMessage );
			registerClassAlias( "com.playtika.casino.common.messages.helpers.UserInfo", UserInfo );
			registerClassAlias( "com.playtika.casino.common.messages.helpers.UserStatus", UserStatus );
			registerClassAlias( "com.playtika.casino.common.messages.helpers.UserLevel", UserLevel );
			
			//tasks
			registerClassAlias( "com.playtika.casino.messages.response.ClientTasksMessage", ClientTasksMessage );
			registerClassAlias( "com.playtika.casino.messages.helpers.ClientTask", ClientTask );
			
			registerClassAlias( "com.playtika.casino.localization.dto.LocalizedEntity", LocalizedEntity );
			registerClassAlias( "com.playtika.casino.localization.dto.LocalizationRequest", LocalizationRequest );
			registerClassAlias( "com.playtika.casino.localization.dto.LocalizationResponse", LocaleResponse );
			
			//payments
			registerClassAlias("com.playtika.casino.messages.request.BuyCoinsRequest", BuyCoinsRequest);
			registerClassAlias("com.playtika.casino.messages.response.BuyCoinsMessage", BuyCoinsMessage);
			registerClassAlias("com.playtika.casino.messages.response.CurrencyCostsMessage", CurrencyCostsMessage);
			registerClassAlias("com.playtika.casino.messages.response.CurrencyCost", CurrencyCost);
			registerClassAlias( "com.playtika.casino.messages.request.TransactionStatusRequest", TransactionStatusRequest );
			registerClassAlias( "com.playtika.casino.messages.response.TransactionStatusMessage", TransactionStatusMessage );
			
			registerClassAlias( "com.playtika.casino.messages.helpers.UpdateRegistrationInfoRequest", UpdateRegistrationInfoRequest );
		}
	}
}