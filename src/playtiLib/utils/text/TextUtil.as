package playtiLib.utils.text {
	
	public class TextUtil {
		
		public static function toCurrency(num:Number, num_div:String = ",", forceDecimals:Boolean = false, dec_div:String = "."):String {
			
			var spt_num:Array = String(num).split(".");
			spt_num[0] = (spt_num[0] == undefined) ? "0" : spt_num[0];
			if (forceDecimals){
				spt_num[1] = (spt_num[1]) ? String(dec_div + spt_num[1]).substr(0, 3) : String(dec_div + "00");
			} else {
				spt_num[1] = (spt_num[1]) ? String(dec_div + spt_num[1]).substr(0, 3) : "";
			}
			var result:String = "";
			
			if (spt_num[0] != "0"){
				var num_arr:Array = String(spt_num[0]).split("");
				num_arr.reverse();
				var pre_num:Array = new Array();
				var i:int = 0;
				for each (var a:String in num_arr){
					if (i < 3 || a == "-"){
						pre_num.push(a);
					} else {
						pre_num.push(num_div);
						pre_num.push(a);
						i = 0;
					}
					i++
				}
				pre_num.reverse();
				var numero:String = "";
				for each (var b:String in pre_num){
					numero += b;
				}
				result = numero + spt_num[1];
			} else {
				result = spt_num[0] + spt_num[1];
			}
			return result;
		}
		
		/**
		 * Static function that gets a number and few conditions and returns a string that represent
		 * that number with those conditions and some mathematical operations.
		 */
		public static function numberFormat(number:*, maxDecimals:uint = 0, minDecimals:uint = 2, siStyle:Boolean = false):String {
			if ( Number(number).toString() == Number.NaN.toString() )
				return "?";
			if (number == 0 && maxDecimals == 0)
				return "0";
//			if (number < 1000)
//				return Number(number).toFixed(maxDecimals);
			if(minDecimals > maxDecimals) {
				minDecimals = maxDecimals;
			}
			var i:int = 0;
			var negative : Boolean = (number < 0);
			var str:String = Math.abs(number).toString();
			var dotPos:int = (hasDot ? str.indexOf(".") : str.length);
			var hasDot:Boolean = (dotPos < str.length);
//			var ret:String = (has_sep && (minDecimals == 0) ? "" : (siStyle ? "," : ".")) + str.substr(sep_pos + 1);
//			if (minDecimals > 0) {
//				while(ret.length <= minDecimals - (str.length - (has_sep ? sep_pos - 1 : sep_pos)); j++) {
//					ret += "0";
//				}
//			}
//			while (i + 3 < (str.substr(0, 1) == "-" ? sep_pos - 1 : sep_pos)) {
//				ret = (siStyle ? "." : ",") + str.substr(sep_pos - (i += 3), 3) + ret;
//			}
//			
//			return str.substr(0, sep_pos - i) + ret;
			
			var integer : String = str.substring(0, dotPos);
			var fractional : String = str.substr(dotPos + 1, maxDecimals);
			
			while(fractional.length < minDecimals) {
				fractional += "0";
			}
			
			var pos : uint;
			for(var sep_count : int = (integer.length - 1) / 3; sep_count > 0; sep_count--) {
				pos = integer.length - (sep_count * 3);
				integer = integer.substring(0, pos) + (siStyle ? "." : ",") + integer.substr(pos);
			}
			
			return (negative ? "-" : "") + integer + ( (fractional.length) ? ( (siStyle ? "," : ".") + fractional ) : "" );
		}
		
		/**
		 * Static function that gets string and an object with some parameters and returns the string
		 * with the object's fields inside it
		 *
		 */
		public static function injectUserParamsToString(str:String, params:Object):String {
			for (var field:String in params)
				str = str.replace("[" + field + "]", params[field]);
			return str;
		}
		
		public static function validateString(input_string:String, reg_exp:RegExp):Boolean {
			var result:Object = reg_exp.exec(input_string);
			if (result == null){
				return false;
			}
			return true;
		}
	}
}