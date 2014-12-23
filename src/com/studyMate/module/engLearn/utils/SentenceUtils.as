package com.studyMate.module.engLearn.utils
{
	
	/**
	 * note
	 * 2014-10-21下午4:27:06
	 * Author wt
	 *
	 */	
	
	public class SentenceUtils
	{
		private static const reg:RegExp = /[a-zA-Z]/;
		private static var indexArr:Array=[];
		private static var allArr:Array = [];
		private static var strTxt:String;
		private static var tempArr:Array=[];//过滤做过的单词
		
		public static function clear():void{
			indexArr.length = 0;
			allArr.length = 0;
			tempArr.length = 0;
			strTxt = '';
		}
		
		/**
		 * 过滤出单词长度＞3的单词。
		 * @param str 断句
		 * @return 过滤后的下标数组
		 */		
		public static function updateFilterTxt(str:String):void{
			strTxt = str;
			allArr = str.split(' ');
			indexArr.length = 0;//下标数组,存储大于2个的下标
			for(var i:int=0;i<allArr.length;i++){
				if(allArr[i].length>2){
					if(allArr[i].length==3){
						if(!reg.test(allArr[i].charAt(2))){
							continue;
						}
					}					
					indexArr.push(i);
				}
			}
			
			tempArr = indexArr.concat();
		}
		
		/**
		 * 根据fileterWord执行后，得到过滤单词数组。从中挖出合适的单词
		 * 如果方案一。中没有过滤出合适的单词。
		 * 则采用方案2.调用blankSentence2。
		 * @return 返回挖掉后句子和被挖的单词
		 * 
		 */		
		public static function blankWord():Object{
			if(indexArr.length==0){
				return blankWord2();
			}
			var obj:Object = {};
			
			
			//获取随机单词
//			var i:int = indexArr.length*Math.random();
//			var word:String = allArr[indexArr[i]];
			if(tempArr.length==0){
				tempArr = indexArr.concat();
			}
			var i:int = tempArr.length*Math.random();
			var word:String = allArr[tempArr[i]];
			
			//过滤特殊符号，提取要挖出的单词
			var index:int = 0;
			var start:int = 0;
			var end:int = 0;
			while(index<word.length-1){
				if(reg.test(word.charAt(index))){
					break;
				}
				index++;
			}
			start = index;
			while(index<word.length){
				if(!reg.test(word.charAt(index))){
					break;
				}
				index++;
			}
			end = index;
			var fillWord:String = word.substring(start,end);
			//			trace("fillWord",fillWord);
			
			var blankStr:String = '';
			for(var j:int = 0;j<fillWord.length;j++){
				blankStr+='_'
			}
			var modify:Array = allArr.concat();
//			modify[indexArr[i]] = word.substring(0,start) + blankStr+ word.substring(end);
			modify[tempArr[i]] = word.substring(0,start) + blankStr+ word.substring(end);
			var blankTxt:String = modify.join(' ');
			//			trace("blankTxt",blankTxt);
			
			
			tempArr.splice(i,1);
			
			obj.fillWord = fillWord;
			obj.blankTxt = blankTxt;
			return obj;
		}
		
		
		
		
		/**
		 * 方案2
		 * 挖空填词算法
		 * 1先检测左侧的第一个是英文的下标
		 * 2然后一直向左查到第一个非英文（即得到单词的头index）
		 * 3再根据index向右查到第一个非英文。即得到单词都未
		 * 4最后再截取即可
		 */		
		private static function blankWord2():Object{
			var obj:Object = {};
			var str:String = strTxt;
			var index:int = Math.random()*str.length;
			
			var len:int = str.length;
			
			var blankStr:String='';
			while(index>0){
				if(reg.test(str.charAt(index))){
					break;
				}
				index--;
			}
			while(index>0){
				if(!reg.test(str.charAt(index))){
					index++;
					break;
				}
				index--;
			}
			var start:int = index;
			while(index<len){
				if(!reg.test(str.charAt(index))){
					break;
				}
				index++;
			}
			for(var i:int = start;i<index;i++){
				blankStr+='_'
			}
			var fillWord:String = str.substring(start,index);
			str = str.substring(0,start) + blankStr+ str.substring(index);
			
			obj.fillWord = fillWord;
			obj.blankTxt = str;
			return obj;
		}
	}
}