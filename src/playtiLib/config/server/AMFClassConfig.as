package playtiLib.config.server
{	
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
	
	import playtiLib.DynamicObject;
	import playtiLib.model.VO.amf.request.BuyCoinsRequest;
	import playtiLib.model.VO.amf.request.ClientRequest;
	import playtiLib.model.VO.amf.request.CouponRequest;
	import playtiLib.model.VO.amf.request.CreateEventCouponRequest;
	import playtiLib.model.VO.amf.request.LocalizationRequest;
	import playtiLib.model.VO.amf.request.LoginRequest;
	import playtiLib.model.VO.amf.request.RegisterRequest;
	import playtiLib.model.VO.amf.request.SessionInfo;
	import playtiLib.model.VO.amf.request.TransactionStatusRequest;
	import playtiLib.model.VO.amf.request.UpdateClientTaskRequest;
	import playtiLib.model.VO.amf.request.UpdateRegistrationInfoRequest;
	import playtiLib.model.VO.amf.request.UpdateUserInfoRequest;
	import playtiLib.model.VO.amf.response.BuyCoinsMessage;
	import playtiLib.model.VO.amf.response.ClientResponse;
	import playtiLib.model.VO.amf.response.ClientTasksMessage;
	import playtiLib.model.VO.amf.response.CollectCouponMessage;
	import playtiLib.model.VO.amf.response.Coupon;
	import playtiLib.model.VO.amf.response.CouponMessage;
	import playtiLib.model.VO.amf.response.CouponReceiversMessage;
	import playtiLib.model.VO.amf.response.CouponsListMessage;
	import playtiLib.model.VO.amf.response.CurrencyCostsMessage;
	import playtiLib.model.VO.amf.response.LocaleResponse;
	import playtiLib.model.VO.amf.response.LoginMessage;
	import playtiLib.model.VO.amf.response.RegisterMessage;
	import playtiLib.model.VO.amf.response.ResultMessage;
	import playtiLib.model.VO.amf.response.ServiceMessage;
	import playtiLib.model.VO.amf.response.TransactionStatusMessage;
	import playtiLib.model.VO.amf.response.UserInfoMessage;
	import playtiLib.model.VO.amf.response.helpers.ClientTask;
	import playtiLib.model.VO.amf.response.helpers.LocalizedEntity;
	import playtiLib.model.VO.amf.response.helpers.UserInfo;
	import playtiLib.model.VO.amf.response.helpers.UserLevel;
	import playtiLib.model.VO.amf.response.helpers.UserStatus;
	import playtiLib.model.VO.payment.CurrencyCost;

	public class AMFClassConfig	{
		
		public static function registerClasses():void {
			
			/////////////////////////////////////////////////////////////////////////
			registerClassAlias("flex.messaging.messages.CommandMessage",CommandMessage);
			registerClassAlias("flex.messaging.messages.RemotingMessage",RemotingMessage);
			registerClassAlias("flex.messaging.messages.AcknowledgeMessage", AcknowledgeMessage);
			registerClassAlias("flex.messaging.messages.ErrorMessage",ErrorMessage);
			registerClassAlias("DSC", CommandMessageExt);
			registerClassAlias("DSK", AcknowledgeMessageExt);
			registerClassAlias("flex.messaging.io.ArrayList", ArrayList);
			registerClassAlias("flex.messaging.config.ConfigMap",ConfigMap);
			registerClassAlias("flex.messaging.io.ArrayCollection",ArrayCollection);
			registerClassAlias("flex.messaging.io.ObjectProxy",ObjectProxy);
			registerClassAlias("flex.messaging.messages.HTTPMessage",HTTPRequestMessage);
			registerClassAlias("flex.messaging.messages.SOAPMessage",SOAPMessage);
			registerClassAlias("flex.messaging.messages.AsyncMessage",AsyncMessage);
			registerClassAlias("DSA", AsyncMessageExt);
			registerClassAlias("flex.messaging.messages.MessagePerformanceInfo", MessagePerformanceInfo);
			/////////////////////////////////////////////////////////////////////////
			
			registerClassAlias("com.playtika.common.exception.PlaytikaException", DynamicObject);
			
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
			
			var target:TraceTarget = new TraceTarget();
			target.level = 0;
		}
	}
}