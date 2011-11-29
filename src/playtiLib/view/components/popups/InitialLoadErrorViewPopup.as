package playtiLib.view.components.popups
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class InitialLoadErrorViewPopup extends Sprite	{
		
		public function InitialLoadErrorViewPopup( title:String, desc:String ){
			
			super();
			var w:int = 450;
			var h:int = 180;
			graphics.lineStyle( 4, 0xEBA62F );
			graphics.beginFill( 0x2C2C2C,1 );
			graphics.drawRoundRectComplex( 0,0,w,h,10,10,10,10 );
			graphics.endFill();
			var title_txt:TextField = addChild( new TextField() ) as TextField;
			title_txt.x = title_txt.y = 10;
			title_txt.width = w-30;
			title_txt.htmlText = '<font size="24" color="#EBA62F">'+title+'</font>';
			var desc_txt:TextField = addChild( new TextField() ) as TextField;
			desc_txt.width = w-30;
			desc_txt.wordWrap = true;
			desc_txt.x = 10; desc_txt.y = 40;
			desc_txt.htmlText = '<font size="17" color="#ffffff">'+desc+'</font>';
		}
	}
}