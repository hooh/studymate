package com.studyMate.view.component.myDrawing.helpFile
{
	/**
	 *该静态函数函数为获取查询阅读一个句子
	 * @param text 文本字符串
	 * @param currentChar 字符索引值
	 * @param search 查询单词的头字符索引或者还是尾字符索引
	 * @return 字符索引
	 */
	public final class IsSentence
	{
		private static const reg1:RegExp = /[\(\d\.\)]/;
		private static const reg:RegExp = /(\(\d*\.\d*\))/;
		
		public static function search(text:String,currentChar:int=0):String{
			var sentence:String='';
			var tempStr:String = '';
			var tempArr:Array=[];
			if(currentChar>text.length){
				return '';
			}
			
			while(reg1.test(text.charAt(currentChar))){
				currentChar++;
				if(currentChar>=text.length){
					currentChar=text.length;
					break;
				}
			}
			
			
			
			tempStr = text.substring(0,currentChar);
			tempArr = tempStr.split(reg);
			if(tempArr.length>1){				
				var preStr:String =tempArr[tempArr.length-2]+ tempArr[tempArr.length-1];	
			}else{
				return '';
				
			}
			
			tempStr = text.substr(currentChar);
			tempArr = tempStr.split(reg);
			if(tempArr.length>0){				
				var nextStr:String = tempArr[0];	
			}else{
				nextStr = '';
			}
			
			
			
			
			return preStr+nextStr;
		}
	}
}