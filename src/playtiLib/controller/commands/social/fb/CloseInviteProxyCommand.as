package playtiLib.controller.commands.social.fb
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.model.proxies.social.fb.SendSocialInviteReqProxy;
	
	public class CloseInviteProxyCommand extends SimpleCommand
	{
		override public function execute( notification:INotification ):void {
			if( facade.hasProxy( SendSocialInviteReqProxy.NAME ) ){
				facade.removeProxy( SendSocialInviteReqProxy.NAME );
			}
		}
	}
}