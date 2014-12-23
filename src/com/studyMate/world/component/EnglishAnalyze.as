package com.studyMate.world.component
{
	import com.studyMate.world.component.offline.FileRead;
	
	import flash.utils.Dictionary;

	public class EnglishAnalyze
	{
		private static var dic:Dictionary;//英美单词区别字典
		
		public function EnglishAnalyze()
		{
		}
		
		/**
		 * 检查匹配
		 * @param userWord		用户输入的单词
		 * @param standardWord	标准单词
		 * @return 若输入单词是英式或美式则true ，反之则false
		 * 
		 */		
		public static function check(userWord:String,standardWord:String):Boolean{
			if(dic==null){
				dic = new Dictionary();
				var value:String = FileRead.getValue("userTestLearn/enListCompare");
//				trace(value);
				var wordArr:Array = value.split('\r\n');
				var key:Array;
				for(var i:int=0,len:int=wordArr.length;i<len;i++){
					key = wordArr[i].split(';');
					dic[key[0]] = key[1];
					dic[key[1]] = key[0];
				}
			}
			
			if(dic[userWord] == standardWord){
				return true;
			}else{
				return false;
			}			
		}
	}
}