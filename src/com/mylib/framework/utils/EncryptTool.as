package com.mylib.framework.utils
{
	import com.hurlant.crypto.prng.ARC4;
	import com.hurlant.util.Hex;
	
	import flash.utils.ByteArray;

	public class EncryptTool
	{
		private static var rc4key:ByteArray = Hex.toArray(Hex.fromString("this is a secret!!!"));
		private static var rc4:ARC4 = new ARC4(rc4key);
		
		public function EncryptTool()
		{
			
		}
		
		public static function encyptRC4(fileName:String):String{
			var pt:ByteArray = Hex.toArray(Hex.fromString(fileName));
			rc4.init(rc4key);
			rc4.encrypt(pt);
			return Hex.fromArray(pt).toUpperCase();
		}
		
		public static function dencyptRC4(fileName:String):String{
			var pt:ByteArray = Hex.toArray(fileName);
			rc4.init(rc4key);
			rc4.decrypt(pt);
			return Hex.toString(Hex.fromArray(pt));
		}
		
		
		
	}
}