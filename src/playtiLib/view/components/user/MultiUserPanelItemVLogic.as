package playtiLib.view.components.user
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import playtiLib.config.notifications.GeneralAppNotifications;
	import playtiLib.model.vo.user.User;
	import playtiLib.model.vo.user.UserSocialInfo;
	import playtiLib.utils.events.EventTrans;
	import playtiLib.utils.warehouse.GraphicsWarehouseList;
	import playtiLib.view.components.btns.ButtonSimple;
	import playtiLib.view.interfaces.IViewLogic;

	/**
	 * Holds panel btn, user mc, loader and a userVO and handle the multi user panel. 
	 * It sets the user parameter that on stage - photo and name. 
	 * @see playtiLib.utils.warehouse.GraphicsWarehouseList
	 * @see flash.display.Loader
	 * @see flash.net.URLRequest
	 */	
	public class MultiUserPanelItemVLogic extends EventDispatcher implements IViewLogic{
		
		protected const USER_NAME_TEXT_MAX_SIZE:uint = 8;
		
		protected var user:User;
		protected var panel_btn:ButtonSimple;
		protected var item_mc:MovieClip;
		protected var person_mc:MovieClip;
		protected var user_photo_loader:Loader;
		public var desiredX:Number;
		
		public function MultiUserPanelItemVLogic( user:User, additional_item_mc:MovieClip = null, user_panel_item:String = 'multi_users_panel_item' )	{
			
			this.user = user;
			if( additional_item_mc != null )
				item_mc = additional_item_mc;
			else
				item_mc = GraphicsWarehouseList.getAsset( user_panel_item ) as MovieClip;
			//if this was additional mc that was witing with preloader to intgration of user_vo remove preloader
			if(item_mc['preloader'].parent)
				item_mc['preloader'].parent.removeChild(item_mc['preloader']);
			
			setUserParams();
		}
		/**
		 * Sets the user parameters, photo and name.  
		 * 
		 */		
		protected function setUserParams():void {
			
			if( user ) {
				//set user photo
				person_mc = item_mc['person_mc'] as MovieClip;
				//check if the userSocialInfo is loaded and if not dispatch event to proxy
				panel_btn = new ButtonSimple( person_mc );
				panel_btn.addEventListener( MouseEvent.CLICK, panelClickHandler );
				if( user.userSocialInfo.isReady ){
					//set name					
					setUserName(person_mc['name_txt'], user.userSocialInfo.first_name);					
					//set photo
					if( user.userSocialInfo.photo ) {
						user_photo_loader = person_mc['photo_holder'].addChild( new Loader ) as Loader;
						user_photo_loader.load( new URLRequest( user.userSocialInfo.photo ) );
						user_photo_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, photoLoaded );
					}
				}
			}
			if( user && !user.userSocialInfo.isReady ){
				user.userSocialInfo.addEventListener( GeneralAppNotifications.USER_SOCIAL_INFO_READY, onUserSocialReady );
				person_mc['name_txt'].text = "";
			}
		}
		
		private function setUserName(nameField:TextField, userName:String):void {
			nameField.text = userName;
			var format:TextFormat = nameField.getTextFormat();
				
			while ((nameField.textWidth > nameField.width-3) && (int(format.size) >= USER_NAME_TEXT_MAX_SIZE)) {
				format.size = int(format.size) - 1;
				nameField.setTextFormat(format);
				format = nameField.getTextFormat();				
			}
		}
		
		private function onUserSocialReady( event:EventTrans ):void{
			user.userSocialInfo.removeEventListener( GeneralAppNotifications.USER_SOCIAL_INFO_READY, onUserSocialReady );
			setUserParams();
		}
		/**
		 * Handles the event COMPLETE of the user photo loader. 
		 * @param event
		 * 
		 */		
		private function photoLoaded( event:Event ):void {
			
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			user_photo_loader.y = ( 50 - user_photo_loader.height ) / 2;
		}
		/**
		 * Handles the mouse event CLICK on the panel btn.
		 * @param event
		 * 
		 */		
		protected function panelClickHandler( event:MouseEvent ):void {
			var userSocialInfo:UserSocialInfo = (user && user.userSocialInfo)? user.userSocialInfo : null;
			
			dispatchEvent( new EventTrans( EventTrans.DATA, userSocialInfo) );
		}
		
		public function update():void {
			
			content.x += ( desiredX-content.x ) * .35;
		}
		
		public function get content():DisplayObject	{
			
			return item_mc;
		}
		
		public function get user_info():User{
			
			return user;
		}
	}
}