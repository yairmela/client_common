package playtiLib.controller.commands.server
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.server.ServerConfig;
	import playtiLib.model.VO.amf.request.SessionInfo;
	import playtiLib.model.proxies.server.AMFServerCallManagerProxy;
	
	public class ServerReloginCompleteCommand extends SimpleCommand
	{
		public override function execute(notification:INotification):void {
			
			serverCallManagerProxy.setFaultHandled(null);
		}
		
		private function get serverCallManagerProxy() : AMFServerCallManagerProxy {
			
			return (facade.retrieveProxy(AMFServerCallManagerProxy.NAME) as AMFServerCallManagerProxy);
		}
	}
}