package playtiLib.controller.commands.content 
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.model.proxies.content.LocaleContentProxy;
	import playtiLib.model.vo.amf.response.helpers.LocaleCommandParams;
	import playtiLib.utils.tracing.Logger;
	
	public class GetLocaleContentCommand extends SimpleCommand 
	{
		override public function execute( notification:INotification ):void
		{
			Logger.log( "LocalizationCommand" );
			
			if  ( !facade.hasProxy( LocaleContentProxy.NAME ) ) 
				facade.registerProxy( new LocaleContentProxy());	
			else
				( facade.retrieveProxy( LocaleContentProxy.NAME ) as LocaleContentProxy ).loadLocaleContent(notification.getBody() as LocaleCommandParams);
		}
	}  
}