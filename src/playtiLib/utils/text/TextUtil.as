package playtiLib.utils.text {
	
	public class TextUtil {
		
		public static function toCurrency(num:Number, num_div:String = ",", decimales:Boolean = false, dec_div:String = "."):String {
			
			var spt_num:Array = String(num).split(".");
			spt_num[0] = (spt_num[0] == undefined) ? "0" : spt_num[0];
			if (decimales){
				spt_num[1] = (spt_num[1] == undefined) ? String(dec_div + "00") : String(dec_div + spt_num[1]).substr(0, 3);
			} else {
				spt_num[1] = "";
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
		public static function numberFormat(number:*, maxDecimals:int = 0, forceDecimals:Boolean = false, siStyle:Boolean = false):String {
			if (Number(number).toString() == Number.NaN.toString())
				return "?";
			if (number == 0 && maxDecimals == 0)
				return "0";
			if (number < 1000)
				return Number(number).toFixed(maxDecimals);
			var i:int = 0;
			var inc:Number = Math.pow(10, maxDecimals);
			var str:String = String((Math.round(inc * Number(number)) / inc).toFixed(maxDecimals));
			var has_sep:Boolean = str.indexOf(".") == -1, sep:int = has_sep ? str.length : str.indexOf(".");
			var ret:String = (has_sep && !forceDecimals ? "" : (siStyle ? "," : ".")) + str.substr(sep + 1);
			if (forceDecimals){
				for (var j:int = 0; j <= maxDecimals - (str.length - (has_sep ? sep - 1 : sep)); j++)
					ret += "0";
			}
			while (i + 3 < (str.substr(0, 1) == "-" ? sep - 1 : sep))
				ret = (siStyle ? "." : ",") + str.substr(sep - (i += 3), 3) + ret;
			
			return str.substr(0, sep - i) + ret;
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