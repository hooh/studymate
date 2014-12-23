package com.studyMate.view.component.myDrawing.helpFile
{
	public final class IsLetter
	{
		private static const reg:RegExp = /[a-zA-Z']/;
		
		/**
		 *该静态函数函数为获取字符串中单词的下标头和下标未的作用 
		 * @param text 文本字符串
		 * @param currentChar 字符索引值
		 * @param search 查询单词的头字符索引或者还是尾字符索引
		 * @return 字符索引
		 */		
		public static function search(text:String,currentChar:int=0,search:String="Left"):int{
			var Char:int = currentChar;
			if(reg.test(text.charAt(currentChar))){
				if(search == "Left"){
					while(Char>=0){
						if(!reg.test(text.charAt(Char))){Char++;break;}
						Char--;
					}
					if(Char < 0) Char=0;
				}else if(search == "Right"){
					var length:int = text.length;
					while(Char <= length){
						if(!reg.test(text.charAt(Char))){Char--;break;}
						Char++;
					}
					if(Char > length) Char = length;					
				}				
			}
			return Char;
		}
		
		/*private static function isLetter(str:String):Boolean{
			var reg:RegExp = /[a-zA-Z']/;
			return reg.test(str);
		}*/
	}
}