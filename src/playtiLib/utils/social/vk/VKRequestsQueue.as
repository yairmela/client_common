package playtiLib.utils.social.vk
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import playtiLib.utils.tracing.Logger;
	
	public class VKRequestsQueue
	{
		
		public static const PRIORITY_HIGH:uint = 0;
		public static const PRIORITY_MEDIUM:uint = 1;
		public static const PRIORITY_LOW:uint = 2; 
		
		
		private static const TIME_FOR_SEND_SEPARATE_REQUESTS:uint = 350;
		private static const COUNT_OF_PRIORITIES:uint = 3;
		private static const REQUEST_ERROR_TO_MANY_RESPONSES:String = "6";
		
		private static var o_timer:Timer;
		//private static var _oApi:IVkontakteApi;
		private static var o_data_provider:VKDataProvider;
		private static var a_queque:Array;
		
		public static function init(oDataProvider:VKDataProvider):void
		{
			o_data_provider = oDataProvider;
			//_oApi = oApi;
			
			
			a_queque = new Array();
			
			a_queque[PRIORITY_HIGH] = new Array();
			a_queque[PRIORITY_MEDIUM] = new Array();
			a_queque[PRIORITY_LOW] = new Array();
			
			o_timer = new Timer(TIME_FOR_SEND_SEPARATE_REQUESTS);
			o_timer.addEventListener(TimerEvent.TIMER, onTimer);
			o_timer.start();
		}
		public static function deconstruct():void
		{
			
			a_queque[PRIORITY_HIGH] = null;
			a_queque[PRIORITY_MEDIUM] = null;
			a_queque[PRIORITY_LOW] = null;
			a_queque = null;
			
			o_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
			o_timer.stop();
		}
		
		public static function addRequest(methodName:String, methodParams:Object, 
										 onCompleteFunc:Function, onErrorFunc:Function, 
										 priority:int = -1):RequestData
		{
			log("addRequest "+ arguments);
			if(priority == -1)
				priority = PRIORITY_MEDIUM;
			var o_request_data:RequestData = new RequestData();
			o_request_data.method_name = methodName;
			o_request_data.method_params = methodParams;
			o_request_data.onCompleteFunc = onCompleteFunc;
			//oRequestData.onErrorFunc = onErrorFunc;
			o_request_data.onErrorFunc = function (error: Object):void
			{
				var old_request_data:RequestData = o_request_data;
				if(!(error is String))
					if(error["error_code"] == REQUEST_ERROR_TO_MANY_RESPONSES)
					{
						VKRequestsQueue.addToQueue(old_request_data);
					}
					else
					{
						onErrorFunc(error);
					}
			}
			
			
			o_request_data.priority = priority;
			
			addToQueue(o_request_data);
			return o_request_data;
		}
		
		public static function removeRequest(oRequestData:RequestData):void
		{
			if(a_queque)
			{
				for (var i:uint = 0; i< a_queque.length; i++)
				{
					var a_priority_array:Array = a_queque[i];
					if(a_priority_array)
					{
						var ind:int = a_priority_array.indexOf(oRequestData); 
						if(ind != -1)
						{
							a_priority_array.splice(ind, 1);
						}
					}
				}
			}
		}
		

// ================= private methods ============================================

		private static function processQueue():void
		{
			var o_request_data:RequestData = getNextRequest();
			if(o_request_data)
				o_data_provider.request(o_request_data.method_name, o_request_data.method_params, 
										 o_request_data.onCompleteFunc, o_request_data.onErrorFunc
										 );
				

				
		}
		private static function getNextRequest():RequestData
		{
			
			if(a_queque)
			{
				for (var i:uint = 0; i< a_queque.length; i++)
				{
					var a_priority_array:Array = a_queque[i];
					if(a_priority_array)
					{
						if(a_priority_array.length > 0)
						{
							var oRequestData:RequestData = a_priority_array.shift();
							log("getNextRequest " + oRequestData.method_name + "  priority: " + i + " remain: " +a_priority_array.length);
							return oRequestData;
						}	
					}
				}
			}
			
			return null;
		}
		
		private static function addToQueue(oRequestData:RequestData ):void
		{
			var a_priority_queue:Array = a_queque[oRequestData.priority];
			a_priority_queue.push(oRequestData);
		}

		private static function traceQueue():void
		{
			var str:String = "";
			for(var i:uint = 0; i<a_queque.length;i++)
			{
				log();
			}
		}

// ---------------- callbacks ---------------------------------------------------
		private static function onTimer(event:TimerEvent):void
		{
			//log("onTimer");
			processQueue();
		}
		
		private static function log(str:String = ""):void
		{
			Logger.log("[RequestsQueue] " + str);
		}
	}

		
}
class RequestData
{
	public var method_name:String = "";
	public var method_params:Object= "";
	public var priority:int= 2;
	public var onCompleteFunc:Function = null;
	public var onErrorFunc:Function = null;
}
