package playtiLib.controller.commands.coupons
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.controller.commands.popup.OpenPopupCommand;
	import playtiLib.model.vo.amf.response.helpers.UserInfo;
	import playtiLib.model.vo.gift.ChooseGift;
	import playtiLib.model.vo.gift.Gift;
	import playtiLib.model.vo.popup.PopupDoActionVO;
	import playtiLib.model.proxies.user.UserProxy;
	import playtiLib.view.mediators.gift.ChooseGiftPopupMediator;
	

	/**
	 * This class has two options: 1. open chooseGiftPopupMediator and then the user will choose gift type or 2. sends CHOOSE_GIFT_COMPLETE - 
	 * in that case - the command should get in its body preGift(ChooseGift) with the gift inside and the keepPreGift property will be true.
	 * In all cases, the notification can carry the sendBack sn id on its type. 
	 */	 
	public class OpenSendGiftPopupCommand extends SimpleCommand	{
		//need to send on the notification - pre gift(chooseGift) and sn_friend_id for sending back
		override public function execute( notification:INotification ):void {

			//incase we come from GCP we have gift and friend id(gift back)
			var choosenGift:ChooseGift = notification.getBody() as ChooseGift;
			if( choosenGift && ( notification.getType() == "" || notification.getType() == null ) ) {
				sendNotification(GeneralAppNotifications.CHOOSE_GIFT_COMPLETE, choosenGift, choosenGift.pre_gift.gift_type.toString());
				return;
			}
			//incase we come from scoreboard we have only friend
			var default_friend:String = notification.getBody() as String;
			if( default_friend && ( notification.getType() == null || notification.getType() == "" ) ) {
				sendNotification( GeneralAppNotifications.OPEN_POPUP,
					new ChooseGiftPopupMediator(default_friend, null, null, new PopupDoActionVO([GeneralAppNotifications.GOTO_GAME_TAB])), OpenPopupCommand.FORCE_OPEN );
				return;
			}
			
			var default_gift_type:int = int(notification.getType());
			//sendGift btn (not gift back&&not from scorebord)
			if (default_gift_type != 3){
				sendNotification( GeneralAppNotifications.OPEN_POPUP,
					new ChooseGiftPopupMediator("0", null, null, new PopupDoActionVO([GeneralAppNotifications.GOTO_GAME_TAB])), OpenPopupCommand.FORCE_OPEN );
				return;
			}
			//if comes from after free spins when you get the chance to send 10 free spin to you friend
			choosenGift = new ChooseGift();
			choosenGift.friend_uid = '0';
			var pre_gift:Gift = new Gift();
			pre_gift.gift_type = 3;
			choosenGift.pre_gift = pre_gift;
			sendNotification( GeneralAppNotifications.CHOOSE_GIFT_COMPLETE, choosenGift, default_gift_type.toString() );
		}
	}
}