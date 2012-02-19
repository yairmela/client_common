package playtiLib.config.server
{	
	import flash.net.getClassByAlias;
	import flash.net.registerClassAlias;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.logging.targets.TraceTarget;
	import mx.messaging.config.ConfigMap;
	import mx.messaging.messages.AcknowledgeMessage;
	import mx.messaging.messages.AcknowledgeMessageExt;
	import mx.messaging.messages.AsyncMessage;
	import mx.messaging.messages.AsyncMessageExt;
	import mx.messaging.messages.CommandMessage;
	import mx.messaging.messages.CommandMessageExt;
	import mx.messaging.messages.ErrorMessage;
	import mx.messaging.messages.HTTPRequestMessage;
	import mx.messaging.messages.MessagePerformanceInfo;
	import mx.messaging.messages.RemotingMessage;
	import mx.messaging.messages.SOAPMessage;
	import mx.utils.ObjectProxy;
	
	import playtiLib.model.vo.amf.request.BuyCoinsRequest;
	import playtiLib.model.vo.amf.request.ClientRequest;
	import playtiLib.model.vo.amf.request.CouponRequest;
	import playtiLib.model.vo.amf.request.CreateEventCouponRequest;
	import playtiLib.model.vo.amf.request.LocalizationRequest;
	import playtiLib.model.vo.amf.request.LoginRequest;
	import playtiLib.model.vo.amf.request.RegisterRequest;
	import playtiLib.model.vo.amf.request.SessionInfo;
	import playtiLib.model.vo.amf.request.TransactionStatusRequest;
	import playtiLib.model.vo.amf.request.UpdateClientTaskRequest;
	import playtiLib.model.vo.amf.request.UpdateRegistrationInfoRequest;
	import playtiLib.model.vo.amf.request.UpdateUserInfoRequest;
	import playtiLib.model.vo.amf.response.BuyCoinsMessage;
	import playtiLib.model.vo.amf.response.ClientResponse;
	import playtiLib.model.vo.amf.response.ClientTasksMessage;
	import playtiLib.model.vo.amf.response.CollectCouponMessage;
	import playtiLib.model.vo.amf.response.Coupon;
	import playtiLib.model.vo.amf.response.CouponMessage;
	import playtiLib.model.vo.amf.response.CouponReceiversMessage;
	import playtiLib.model.vo.amf.response.CouponsListMessage;
	import playtiLib.model.vo.amf.response.CurrencyCostsMessage;
	import playtiLib.model.vo.amf.response.LocaleResponse;
	import playtiLib.model.vo.amf.response.LoginMessage;
	import playtiLib.model.vo.amf.response.RegisterMessage;
	import playtiLib.model.vo.amf.response.ResultMessage;
	import playtiLib.model.vo.amf.response.ServiceMessage;
	import playtiLib.model.vo.amf.response.TransactionStatusMessage;
	import playtiLib.model.vo.amf.response.UserInfoMessage;
	import playtiLib.model.vo.amf.response.helpers.ClientTask;
	import playtiLib.model.vo.amf.response.helpers.LocalizedEntity;
	import playtiLib.model.vo.amf.response.helpers.UserInfo;
	import playtiLib.model.vo.amf.response.helpers.UserLevel;
	import playtiLib.model.vo.amf.response.helpers.UserStatus;
	import playtiLib.model.vo.payment.CurrencyCost;

	public class AMFGeneralClassConfig	{
		
		public static function registerClasses():void {
			
			/////////////////////////////////////////////////////////////////////////
			registerClassAlias("flex.messaging.messages.RemotingMessage", RemotingMessage);
			registerClassAlias("flex.messaging.messages.CommandMessage",CommandMessage);
			registerClassAlias("flex.messaging.messages.AcknowledgeMessage", AcknowledgeMessage);
			registerClassAlias("flex.messaging.messages.ErrorMessage", ErrorMessage);
			registerClassAlias("DSC", CommandMessageExt);
			registerClassAlias("DSK", AcknowledgeMessageExt);
			registerClassAlias("flex.messaging.io.ArrayList", ArrayList);
			registerClassAlias("flex.messaging.config.ConfigMap", ConfigMap);
			registerClassAlias("flex.messaging.io.ArrayCollection", ArrayCollection);
			registerClassAlias("flex.messaging.io.ObjectProxy", ObjectProxy);
			
			// You may want to register pub/sub and other rpc message types too...
			registerClassAlias("flex.messaging.messages.HTTPMessage", HTTPRequestMessage);
			registerClassAlias("flex.messaging.messages.SOAPMessage", SOAPMessage);
			registerClassAlias("flex.messaging.messages.AsyncMessage", AsyncMessage);
			registerClassAlias("DSA", AsyncMessageExt);
			registerClassAlias("flex.messaging.messages.MessagePerformanceInfo", MessagePerformanceInfo);
			/////////////////////////////////////////////////////////////////////////
						
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
			registerClassAlias( "com.playtika.casino.messages.request.UpdateClientTaskRequest", UpdateClientTaskRequest );
			
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