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
	import playtiLib.utils.statistics.TrackSnapshot;
	import playtiLib.utils.statistics.Tracker;

	public class StatisticsTrackingCommand extends SimpleCommand
	{
		public override function execute(notification:INotification):void {
			super.execute(notification);
			
			Tracker.track( notification.getType(), createSnapshot(notification.getBody()) );
		}

		protected function createSnapshot( dynamic_data : Object ):TrackSnapshot {
			
			if( facade.hasProxy(UserProxy.NAME) ) {
				var user_level : UserLevel = user_proxy.user_level;
				var user_info : UserInfo = user_proxy.user_info;
			}
			if( facade.hasProxy(FlashVarsProxy.NAME) ) {
				var flash_vars : FlashVarsVO = flash_vars_proxy.flash_vars;
			}

			return new TrackSnapshot(user_level, user_info, flash_vars, dynamic_data);
		}
		
		protected function get user_proxy() : UserProxy {
			
			return (facade.retrieveProxy(UserProxy.NAME) as UserProxy);
		}
		
		protected function get flash_vars_proxy() : FlashVarsProxy {
			
			return (facade.retrieveProxy(FlashVarsProxy.NAME) as FlashVarsProxy);
		}
	}
}