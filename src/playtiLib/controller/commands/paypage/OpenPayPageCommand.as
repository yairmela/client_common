package playtiLib.controller.commands.paypage
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.AMFGeneralCallsConfig;
	import playtiLib.config.server.GeneralCallsConfig;
	import playtiLib.config.server.ServerConfig;
	import playtiLib.config.social.SocialConfig;
	import playtiLib.config.statistics.GeneralStatistics;
	import playtiLib.model.VO.user.UserSocialInfo;
	import playtiLib.model.proxies.payment.CurrencyCostProxy;
	import playtiLib.model.proxies.user.UserProxy;
	import playtiLib.utils.data.DataCapsule;
	import playtiLib.utils.data.DataCapsuleFactory;
	import playtiLib.utils.data.DataHolder;
	import playtiLib.utils.network.URLUtil;
	import playtiLib.utils.statistics.Tracker;
	import playtiLib.view.mediators.paypage.PayPageShellMediator;

	/**
	 * Gets user id from the notification body and loads the paypage loader and registers a PayPageShellMediator. It gets some data from
	 * server GET_CHIPS_INFO and in the end of the procces, it sends notification PAYTABLE_DATA_READY.
	 */	
	public class OpenPayPageCommand extends SimpleCommand{
		
		override public function execute( notification:INotification ):void {
			
			var override_user_id:String = notification.getBody() ? String( notification.getBody() ) : '' ;
			
			var user_proxy:UserProxy = facade.retrieveProxy( UserProxy.NAME ) as UserProxy;
			var user_id:String = ( override_user_id == '' ) ? SocialConfig.viewer_sn_id : override_user_id;
			var paypage_loader:Loader = new Loader;
			paypage_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onPayPageLoaded );
			
			var context:LoaderContext = new LoaderContext( true, ApplicationDomain.currentDomain );
			var link:String =  ServerConfig.ASSETS_SERVER_IP + 'res/paypage/pay_page.swf?user_id=' + user_id + '&math=1&cache_id=' + ServerConfig.PAYPAGE_CACHE_ID;
			if( !URLUtil.isRunnedLocaly() )
				context.securityDomain = SecurityDomain.currentDomain; 
			
			var url_req:URLRequest = new URLRequest( link ); 
			paypage_loader.load( url_req, context );

			facade.registerMediator( new PayPageShellMediator( paypage_loader ) );
			
			sendNotification(GeneralAppNotifications.TRACK, {buy_type: notification.getBody()["buyType"]}, GeneralStatistics.OPEN_PAY_PAGE);
		}
		/**
		 * Gets loader info object and adds it listeners(complete and errors)
		 * @param event
		 * 
		 */		
		private function onPayPageLoaded( event:Event ):void {
			
			var loader_inf:LoaderInfo = event.currentTarget as LoaderInfo;
			loader_inf.content.addEventListener( Event.COMPLETE, loadChipsInfoAfterInit );
			loader_inf.content.addEventListener( IOErrorEvent.IO_ERROR,  trace );
		}
		/**
		 * Gets data capsule from the dataCapsuleFactory (GET_CHIPS_INFO) and loads the data and adds COMPLETE and IO_ERROR events.
		 * @param event
		 * 
		 */		
		private function loadChipsInfoAfterInit( event:Event ):void {
			
			var pay_info_capsule:DataCapsule = DataCapsuleFactory.getDataCapsule( [AMFGeneralCallsConfig.GET_CURRENCY_COSTS] );
			pay_info_capsule.addEventListener( Event.COMPLETE, onGetPayInfo );
			pay_info_capsule.addEventListener( IOErrorEvent.IO_ERROR,  trace );
			pay_info_capsule.loadData();
		}
		/**
		 * Called when the data(GET_CHIPS_INFO) in the dataCapsule object is complete loaded, remove it's listener(complete). 
		 * If facade doesn't have CurrencyCostProxy - it makes new one and also sets the cuurent cost list in the cuurent cost proxy 
		 * by the data holder from the dataCapsule. It also sends notification PAYTABLE_DATA_READY.
		 * 
		 * @param event
		 * 
		 */		
		private function onGetPayInfo( event:Event ):void	{
			
			var pay_info_capsule:DataCapsule = event.currentTarget as DataCapsule;
			pay_info_capsule.removeEventListener( Event.COMPLETE, onGetPayInfo );
			
			var data:DataHolder = pay_info_capsule.getDataHolderByIndex(0);
			var currency_cost_list:Array = data.data as Array;
			
			if( !facade.hasProxy( CurrencyCostProxy.NAME ) )
				facade.registerProxy(new CurrencyCostProxy());
			
			currencyCostProxy.setCurrencyCostList( currency_cost_list );
			
			sendNotification( GeneralAppNotifications.PAYTABLE_DATA_READY, currency_cost_list );
		}
		
		public function get currencyCostProxy():CurrencyCostProxy{
			
			return facade.retrieveProxy( CurrencyCostProxy.NAME ) as CurrencyCostProxy;
		}
	}
}