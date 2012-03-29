package playtiLib.controller.commands.coupons
{
	import flash.display.MovieClip;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import playtiLib.config.gifts.CouponSystemConfig;
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.config.server.ServerConfig;
	import playtiLib.model.vo.gift.ChooseGift;
	import playtiLib.model.vo.gift.Gift;
	import playtiLib.model.vo.social.SocialPostVO;
	import playtiLib.utils.locale.TextLib;
	import playtiLib.utils.warehouse.GraphicsWarehouseList;
	/**
	 * Gets on the notification a chooseGift object and the gift Id in the notification type. It retreive all the coupon's information and
	 * send the CREATE_COUPON_NOTIFICATION notification
	 */	
	public class ChooseGiftCompleteCommand  extends SimpleCommand	{
		
		override public function execute( notification:INotification ):void {

			var gift_data:ChooseGift 	= notification.getBody() as ChooseGift;
			var default_friend:String 	= gift_data.friend_uid;
			var new_gift:Gift 			= new Gift();
			new_gift.gift_type 			= int( notification.getType() );
			
			var publish_event_type:int = -1;
			publish_event_type = new_gift.gift_type == CouponSystemConfig.GIFT_TYPE_COINS ?	
					( gift_data.pre_gift ? 	CouponSystemConfig.EVENT_COINS_RE_GIFT : CouponSystemConfig.EVENT_COINS_GIFT ) : 
					new_gift.gift_type;
			
			var gift_mc:MovieClip = GraphicsWarehouseList.getAsset( 'gift_' + new_gift.gift_type ) as MovieClip;
			var post_vo:SocialPostVO = new SocialPostVO( default_friend, 
				gift_mc, 
				TextLib.lib.retrive( 'wall_posts.gifts.gift_' + new_gift.gift_type + '.desc' ), 
				TextLib.lib.retrive( 'wall_posts.gifts.gift_' + new_gift.gift_type + '.title' ), 
				ServerConfig.ASSETS_SERVER_IP + 'core/img/gifts/gift_'+new_gift.gift_type + '.png', publish_event_type);
			post_vo.is_gift = true;
			post_vo.gift_type = new_gift.gift_type;
			
			sendNotification( GeneralAppNotifications.PUBLISH_GIFT_COMMAND, post_vo );
		}
	}
}