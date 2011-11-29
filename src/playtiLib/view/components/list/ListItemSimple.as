package playtiLib.view.components.list
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import playtiLib.view.components.btns.RadioButtonSimple;

	public class ListItemSimple extends RadioButtonSimple { 
		
		static protected const DEFAULT_TEXT_FIELD_NAME : String = "text";
		
		public function ListItemSimple( content : MovieClip, additionalParams : Object = null )	{
			
			super( content );
			
			var item_texts : Object = getFieldSafe( additionalParams, "itemText", null );
			
			if( !item_texts )  
				return;
			if( item_texts is String ) {
				SetText( item_texts as String );
			}
			else {
				for( var text_field_name : String in item_texts ) 
					SetText( item_texts[text_field_name], text_field_name );
			}
		}
		
		static public function getFieldSafe( obj : Object, field : *, defaultValue : * = null ) : *	{
			
			var result : Object;
			try {
				if( obj.hasOwnProperty( field ) ) 
					result = obj[field];
				else 
					result = defaultValue;
			}
			catch(error : Error) {
				result = defaultValue;
			}
			
			return result;
		}
		
		public function SetText( text : String, textFieldName : String = DEFAULT_TEXT_FIELD_NAME ) : void	{
			
			var text_field : TextField = content.getChildByName( textFieldName ) as TextField;
			
			if( !text_field ) {
				//TODO: can we delete this ?
				//LogError("Can't set item text - TextField \""+ textFieldName +"\" was not found.");
				return;
			}
			
			setText( text_field, text );
		}
		
		public function GetText( textFieldName : String = DEFAULT_TEXT_FIELD_NAME ) : String{
			
			var text_field : TextField = content.getChildByName( textFieldName ) as TextField;
			
			if( !text_field ) {
				//TODO: can we delete this??
				//LogError("Can't get item text - TextField \""+ textFieldName +"\" was not found.");
				return null;
			}
			
			return text_field.text;
		}
		
		static public function setText( textField : TextField, text : String ) : void	{
			
			// Warning: have to re-set text format after assigning text to preserve bold feature, etc...(
			var text_format : TextFormat = textField.getTextFormat();
			
			textField.text = unescape(text);
			
			textField.setTextFormat(text_format);
			//TODO: can we delete this??
			//textField.parent.dispatchEvent( new WindowEvent(WindowEvent.CHILD_TEXT_CHANGE, textField) );
		}
	}
}