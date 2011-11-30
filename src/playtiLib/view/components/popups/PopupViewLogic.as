package playtiLib.view.components.popups
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;

	import playtiLib.utils.warehouse.GraphicsWarehouseList;
	import playtiLib.view.components.btns.ButtonSimple;
	import playtiLib.view.interfaces.IViewLogic;
	/**
	 * Represent the basic logic of the popup. It holds do btns and close btns arrays, the mc of the main area of the popup and some more
	 * display objects. has some basic functionality that all the popup shered (center popup, set position)Registers several optional btns 
	 * like exit, cancel, skip, close, ok, yes and more.
	 * @see playtiLib.utils.warehouse.GraphicsWarehouseList
	 * @see playtiLib.view.interfaces.IViewLogic
	 * @see flash.display.DisplayObject
	 */
	public class PopupViewLogic extends EventDispatcher implements IViewLogic	{
		
		//if this params will not set the logic will use stage height and width
		public static var POPUPS_CENTER_TO_WIDTH:Number;
		public static var POPUPS_CENTER_TO_HEIGHT:Number;

		protected var addition_popup_display:DisplayObject;
		protected var popup_content:DisplayObject;
		protected var popup_mc:MovieClip;
		protected var popup_main_area:DisplayObject;

		private var close_btns:Array = [];
		private var do_btns:Array = [];

		private var initial_popup_rect : Rectangle;

		public function PopupViewLogic( popup_name:String, addition_popup_display:DisplayObject = null, add_show_anim:Boolean = true )	{
			
			this.addition_popup_display = addition_popup_display;
			//if dispaly is movieclip set it to popup_mc
			if( addition_popup_display is MovieClip )
				popup_mc = addition_popup_display as MovieClip;
			//if there is popup name it will override the prev additional display
			if( popup_name != null && GraphicsWarehouseList.hasAsset( popup_name ) )
				popup_mc = GraphicsWarehouseList.getAsset( popup_name ) as MovieClip;

			var display:DisplayObject = (popup_mc) ? popup_mc : addition_popup_display;
			if( add_show_anim ) {
				popup_content = GraphicsWarehouseList.getAsset( 'popup_anim' );
				//add display to popup_amin mc
				popup_content['popup_con'].addChild( display );
				display.addEventListener( Event.ADDED_TO_STAGE, startPopupAnim );
			} else  
				popup_content = display;

			if( !popup_mc ) {
				popup_main_area = popup_content;
			}else {
				popup_main_area = DisplayObjectContainer(popup_mc).getChildByName("main_area");
				if(!popup_main_area) {
					popup_main_area = popup_content;
				}
			}

			initial_popup_rect = popup_main_area.getBounds(popup_content.parent);
			//check for popup_mc general buttons
			registerDoAndCloseBtns(popup_mc);
		}
		/**
		 * Checks if the container mc isn't null and push all the btns(all close and do btns) to the currect btn list.
		 * @param container_mc
		 * 
		 */
		protected function registerDoAndCloseBtns( container_mc:MovieClip ):void {
			
			if( container_mc == null ) return;
			//set close btns
			registerButton( container_mc, 'exit', close_btns );
			registerButton( container_mc, 'x_btn', close_btns );
			registerButton( container_mc, 'cancel_btn', close_btns );
			registerButton( container_mc, 'skip_btn', close_btns );
			registerButton( container_mc, 'close_btn', close_btns );
			registerButton( container_mc, 'no_btn', close_btns );
			registerButton( container_mc, 'ok_btn', close_btns );
			//set do buttons
			registerButton( container_mc, 'yes_btn', do_btns );
			registerButton( container_mc, 'do_btn', do_btns );
			var do_index:int = 2;
			while( registerButton( container_mc, 'do_btn_' + do_index, do_btns ) ) {
				do_index++;
			}
		}
		/**
		 * Checks if the container mc has property with the btn name and if it isn't null and if one of this is false, 
		 * it returns false. If not, it pushes the btn to the btns list (if the list isn't null) and returns true. 
		 * @param container_mc
		 * @param btn_name
		 * @param btns_list
		 * @return 
		 * 
		 */
		private function registerButton( container_mc:MovieClip, btn_name:String, btns_list:Array = null ):Boolean {
			
			if( !container_mc.hasOwnProperty( btn_name ) ||  container_mc[btn_name]==null )
				return false;
			var btn:ButtonSimple = new ButtonSimple( container_mc[btn_name] as MovieClip );
			if( btns_list )
				btns_list.push( btn );
			return true;
		}

		private function startPopupAnim( event:Event ):void {
			
			( popup_content as MovieClip ).gotoAndPlay(1);
		}

		public function get close_btns_list():Array {
			
			return close_btns.concat();
		}

		public function get do_btns_list():Array {
			
			return do_btns.concat();
		}

		public function get content():DisplayObject {
			
			return popup_content;
		}
		/**
		 * Sets the position of the popup display object to the center of the stage.
		 */
		public function centerPopup():void {
			
			var stage_width:Number = isNaN( POPUPS_CENTER_TO_WIDTH ) ? popup_content.stage.stageWidth : POPUPS_CENTER_TO_WIDTH;
			var stage_height:Number = isNaN( POPUPS_CENTER_TO_HEIGHT ) ? popup_content.stage.stageHeight : POPUPS_CENTER_TO_HEIGHT;
			setPosition((stage_width - initial_popup_rect.width)/2-initial_popup_rect.x, (stage_height-initial_popup_rect.height)/2-initial_popup_rect.y);
		}
		/**
		 * Sets the x and y position of the popup display object. 
		 */
		public function setPosition( x:Number, y:Number):void {
			
			popup_content.x = x;
			popup_content.y = y;
		}
	}
}