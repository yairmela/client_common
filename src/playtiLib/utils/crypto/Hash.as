package playtiLib.utils.crypto
{
	public class Hash{		
		public function Hash() {
			
		}
		
		public static function RSHash(str:String):uint{
			
			var b:uint=378551;
			var a:uint=63689;
			var hash:uint=0;
			for (var i:int=0; i < str.length; i++){
				hash=hash * a + uint(str.charCodeAt(i));
				a=a * b;
			}
			
			return hash;
		}
		
		public static function JSHash(str:String):uint{
			
			var hash:uint=1315423911;
			for (var i:int=0; i < str.length; i++){
				hash^=((hash << 5) + uint(str.charCodeAt(i)) + (hash >> 2));
			}
			return hash;
		}
		
		public static function PJWHash(str:String):uint{
			
			var BitsInUnsignedInt:uint=uint(4 * 8);
			var ThreeQuarters:uint=(uint)((BitsInUnsignedInt * 3) / 4);
			var OneEighth:uint=(uint)(BitsInUnsignedInt / 8);
			var HighBits:uint=(uint)(0xFFFFFFFF) << (BitsInUnsignedInt - OneEighth);
			var hash:uint=0;
			var test:uint=0;
			for (var i:int=0; i < str.length; i++){
				hash=(hash << OneEighth) + uint(str.charCodeAt(i));
				if ((test=hash & HighBits) != 0){
					hash=((hash ^ (test >> ThreeQuarters)) & (~HighBits));
				}
			}
			return hash;
		}
		
		public static function ELFHash(str:String):uint{
			
			var hash:uint=0;var x:uint=0;
			for (var i:int=0; i < str.length; i++){
				hash=(hash << 4) + uint(str.charCodeAt(i));
				x=hash & 0xF0000000;
				if (x != 0){      
					hash^=(x >> 24);
				}
				hash&=~x;
			}  
			return hash;
		}
		
		public static function BKDRHash(str:String):uint{
			
			var seed:uint=131; // 31 131 1313 13131 131313 etc..
			var hash:uint=0;
			for (var i:int=0; i < str.length; i++){
				hash=(hash * seed) + uint(str.charCodeAt(i));
			}
			return hash;
		}
		
		public static function SDBMHash(str:String):uint{
			
			var hash:uint=0;
			for (var i:int=0; i < str.length; i++){
				hash=uint(str.charCodeAt(i)) + (hash << 6) + (hash << 16) - hash;
			}
			return hash;
		}
		
		public static function DJBHash(str:String):uint{
			
			var hash:uint=5381;
			for (var i:int=0; i < str.length; i++){
				hash=((hash << 5) + hash) + uint(str.charCodeAt(i));
			}
			return hash;
		}
		
		public static function DEKHash(str:String):uint{
			
			var hash:uint=str.length;
			for (var i:int=0; i < str.length; i++){
				hash=((hash << 5) ^ (hash >> 27)) ^ uint(str.charCodeAt(i));
			}
			return hash;
		}
		
		public static function BPHash(str:String):uint{
			
			var hash:uint=0;
			for (var i:int=0; i < str.length; i++){
				hash=hash << 7 ^ uint(str.charCodeAt(i));
			}
			return hash;
		}
		
		public static function FNVHash(str:String):uint{
			
			var fnv_prime:uint=0x811C9DC5;
			var hash:uint=0;
			for (var i:int=0; i < str.length; i++){
				hash*=fnv_prime;
				hash^=uint(str.charCodeAt(i));
			}
			return hash;
		}
		
		public static function APHash(str:String):uint{
			
			var hash:uint=0xAAAAAAAA;
			var tmp:uint;for (var i:int=0; i < str.length; i++){
				tmp=uint(str.charCodeAt(i));
				if ((i & 1) == 0){
					hash^=((hash << 7) ^ tmp * (hash >> 3));
				}else{
					hash^=(~((hash << 11) + tmp ^ (hash >> 5)));
				}
			}
			return hash;
		}
	}  
}