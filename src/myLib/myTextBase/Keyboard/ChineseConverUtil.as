package myLib.myTextBase.Keyboard
{
	import com.studyMate.global.Global;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.utils.StringUtil;

	/**
	 * 中文反查首字母简拼
	 * @author wt
	 * 
	 */	
	//测试 internal
	internal final class ChineseConverUtil
	{
		private static const notChineseFlag:String = "0";
		private static var cnSpellDic:Dictionary;//长： [chang,zhang]
		
		
		public static function convertChineseArr(chinese:String):Vector.<String>{
			if(cnSpellDic==null){
				var file:File = File.documentsDirectory.resolvePath(Global.localPath+"CNSpelling.txt");
				if(file.exists){					
					try{
						var fileStream:FileStream = new FileStream();
						fileStream.open(file, FileMode.READ);
						var str:String = StringUtil.trim(fileStream.readMultiByte(file.size, "cn-gb"));
						fileStream.close();
						var arr:Array = str.split('\n');					
					}catch(e:Error){
						arr = [];
					}
				}else{
					arr = [];
				}

				cnSpellDic = new Dictionary();
				var len:int = arr.length;
				for(var i:int=0;i<len;i++){						
					cnSpellDic[arr[i].charAt(0)] = arr[i].split("|")[2];					
				}
				
			}
			
			
			var cnlen:int = chinese.length;
			var pinyinArr:Vector.<Array> = new Vector.<Array>;//所有汉字的拼音数组，n个数组
			for (i = 0; i < cnlen; i++)
			{
				var key:String = chinese.charAt(i);
				if(cnSpellDic[key]){
					pinyinArr.push(cnSpellDic[key].split(''));
				}else{
					pinyinArr.push([convertChar(key)]);
				}
			}
			
			var vec:Vector.<String> = get_all_combination(pinyinArr);			
			return vec;
		}
		
		/**
		 * 算法是：求从n个数组任意各选取一个元素的所有组合 (这算法挺难的，根据网上的c算法翻译过来的的 ：http://bbs.csdn.net/topics/330006735)
		 * @param vec　传入多维数组，
		 * @return 范围所有组合的string数组
		 */		
		private static function  get_all_combination(vec:Vector.<Array>):Vector.<String>
		{
			var tmp_vec:Vector.<String> = new Vector.<String>;
			var tmp_result:Vector.<String> = new Vector.<String>;
			get_result_in_vector(vec,0,tmp_vec, tmp_result);
			
			return tmp_result;
		}				
		private static function get_result_in_vector( vec:Vector.<Array>,cur:int,tmp:Vector.<String>, tmp_result:Vector.<String> ):void{
			for(var i:int=0;i< vec[cur].length;++i)
			{
				tmp.push(vec[cur][i]);
				if(cur<vec.length-1)
				{
					get_result_in_vector(vec,cur+1,tmp, tmp_result);
				}
				else
				{
					var one_result:Vector.<String> = new Vector.<String>;
					for(var j:int=0;j<tmp.length;++j)
					{
						one_result.push(tmp[j]);
					}
					tmp_result.push(one_result.join(''));
				}
				tmp.pop();
			}								
		}
		
		public static function convertChineseString(chinese:String):String{
			var len:int = chinese.length;
			var ret:String = "";
			for (var i:int = 0; i < len; i++)
			{
				var char:String = convertChar(chinese.charAt(i));
				if(char != notChineseFlag) {
					ret += char;
				}
			}
			return ret;
			
		}
		private static function convertChar(chineseChar:String):String{
			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(chineseChar.charAt(0), "cn-gb");
			var n:int = bytes[0] << 8;
			n += bytes[1];
			if (isIn(0xB0A1, 0xB0C4, n)) return "a";
			if (isIn(0XB0C5, 0XB2C0, n)) return "b";
			if (isIn(0xB2C1, 0xB4ED, n)) return "c";
			if (isIn(0xB4EE, 0xB6E9, n)) return "d";
			if (isIn(0xB6EA, 0xB7A1, n)) return "e";
			if (isIn(0xB7A2, 0xB8C0, n)) return "f";
			if (isIn(0xB8C1, 0xB9FD, n)) return "g";
			if (isIn(0xB9FE, 0xBBF6, n)) return "h";
			if (isIn(0xBBF7, 0xBFA5, n)) return "j";
			if (isIn(0xBFA6, 0xC0AB, n)) return "k";
			if (isIn(0xC0AC, 0xC2E7, n)) return "l";
			if (isIn(0xC2E8, 0xC4C2, n)) return "m";
			if (isIn(0xC4C3, 0xC5B5, n)) return "n";
			if (isIn(0xC5B6, 0xC5BD, n)) return "o";
			if (isIn(0xC5BE, 0xC6D9, n)) return "p";
			if (isIn(0xC6DA, 0xC8BA, n)) return "q";
			if (isIn(0xC8BB, 0xC8F5, n)) return "r";
			if (isIn(0xC8F6, 0xCBF9, n)) return "s";
			if (isIn(0xCBFA, 0xCDD9, n)) return "t";
			if (isIn(0xCDDA, 0xCEF3, n)) return "w";
			if (isIn(0xCEF4, 0xD1B8, n)) return "x";
			if (isIn(0xD1B9, 0xD4D0, n)) return "y";
			if (isIn(0xD4D1, 0xD7F9, n)) return "z";
			return notChineseFlag;
		}
		private static function isIn(from:int, to:int, value:int):Boolean
		{  
			return ((value >= from) && (value <= to));
		}
	}
}