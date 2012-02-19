package playtiLib.controller.commands.social.fb
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.model.proxies.social.fb.SendSocialGiftsReqProxy;
	
	public class CloseSendGiftProxyCommand extends SimpleCommand
	{
		override public function execute( notification:INotification ):void {
			if( facade.hasProxy( SendSocialGiftsReqProxy.NAME ) ){
				facade.removeProxy( SendSocialGiftsReqProxy.NAME );
			}
		}
	}
}