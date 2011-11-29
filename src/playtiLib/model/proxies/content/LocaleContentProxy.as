package playtiLib.model.proxies.content 
{
	import flash.events.Event;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import playtiLib.config.content.LocaleContentConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.model.VO.amf.response.ClientResponse;
	import playtiLib.model.VO.amf.response.helpers.LocaleCommandParams;
	import playtiLib.model.VO.amf.response.LocaleResponse;
	import playtiLib.utils.data.ContentDataCallConfig;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.utils.warehouse.LocaleContentWarehouse;
	
	public class LocaleContentProxy extends Proxy
	{
		public static const NAME:String = "LocalizationProxy";
		
		public function LocaleContentProxy() 
		{
			super(NAME, new LocaleContentWarehouse());
		}
		
		public function loadLocaleContent(params:LocaleCommandParams):void
		{
			params.lang = LocaleContentConfig.language;
			params.techName = LocaleContentWarehouse.filterLoadedContent(params);
			
			var dataCallConfig:ContentDataCallConfig = AMFGeneralCallsConfig.LOCALIZATION;
			dataCallConfig.setRequestProperties(params);
			var dataCapsule:DataCapsule = DataCapsuleFactory.getDataCapsule([dataCallConfig]);
			dataCapsule.addEventListener( Event.COMPLETE, onLocalContentRecieved);
			dataCapsule.loadData();
		}
		
		private function onLocalContentRecieved(event:Event):void 
		{
			var dataCapsule:DataCapsule = event.currentTarget as DataCapsule;
			dataCapsule.removeEventListener( Event.COMPLETE, onLocalContentRecieved);
			
			var localeResponse:LocaleResponse = (dataCapsule.getDataHolderByIndex(0).server_response as ClientResponse).result as LocaleResponse;
			LocaleContentWarehouse.addNewContent(localeResponse);
			
			sendNotification(GeneralAppNotifications.LOCALE_CONTENT_LOADED, {category:localeResponse.category} );
		}
	}
}