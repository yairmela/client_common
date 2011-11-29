package playtiLib.controller.commands.social.vk
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.model.VO.social.SocialConfigVO;
	import playtiLib.model.proxies.config.AppConfigProxy;
	import playtiLib.model.proxies.data.FlashVarsProxy;
	import playtiLib.utils.social.vk.VkWrapperUtil;
	import playtiLib.utils.tracing.Logger;
	
	public class VKInitConnectionsCommand extends SimpleCommand
	{
		override public function execute( notification:INotification ):void {
			Logger.log("VKInitConnectionsCommand");
			var socia_vonfig_vo:SocialConfigVO = notification.getBody() as SocialConfigVO;
			
			//IF VK REGISTER THIS
			VkWrapperUtil.getInstance().init();
		}
	}
}