package playtiLib.controller.commands.statistics
{
	import org.casalib.events.RetryEvent;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.model.VO.FlashVarsVO;
	import playtiLib.model.VO.amf.response.helpers.UserInfo;
	import playtiLib.model.VO.amf.response.helpers.UserLevel;
	import playtiLib.model.VO.user.UserSocialInfo;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.model.proxies.user.UserProxy;
	import playtiLib.utils.core.ObjectUtil;
	import playtiLib.utils.statistics.GeneralTrackSnapshot;
	import playtiLib.utils.statistics.Tracker;

	public class GeneralStatisticsTrackingCommand extends SimpleCommand
	{
		public override function execute(notification:INotification):void {
			
			super.execute(notification);
			
			Tracker.track( notification.getType(), createSnapshot(notification.getBody()) );
		}

		protected function createSnapshot( dynamicData : Object ):GeneralTrackSnapshot {
			
			var snapshot : GeneralTrackSnapshot = new snapshotClass();
			
			if( facade.hasProxy(UserProxy.NAME) ) {
				snapshot.user_level = userProxy.user_level;
				snapshot.user_info = userProxy.user_info;
			}
			if( facade.hasProxy(FlashVarsProxy.NAME) ) {
				snapshot.flash_vars = flashVarsProxy.flash_vars;
			}
			
			ObjectUtil.setMatchingProperties(dynamicData, snapshot);

			return snapshot;
		}
		
		protected function get snapshotClass() : Class {
			
			return GeneralTrackSnapshot;
		}
		
		protected function get userProxy() : UserProxy {
			
			return (facade.retrieveProxy(UserProxy.NAME) as UserProxy);
		}
		
		protected function get flashVarsProxy() : FlashVarsProxy {
			
			return (facade.retrieveProxy(FlashVarsProxy.NAME) as FlashVarsProxy);
		}
	}
}