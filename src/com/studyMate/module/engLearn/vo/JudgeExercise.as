package com.studyMate.module.engLearn.vo
{
	
	
	public class JudgeExercise 
	{

		public static function checkAnswer(user:String,standard:String):Boolean{
			if(processString(user) == processString(standard)) return true;
			var userArr:Array = processString(user).split('/');
			var answerArr:Array = processString(standard).split('&');
			
			//这部分算法是检测匹配数组1是否完全包含与数组2 包含关系
			for(var i:int=0;i<userArr.length;i++){
				var isRight:Boolean=false;
				for(var j:int=0;j<answerArr.length;j++){
					if(userArr[i] == answerArr[j]){	
						isRight = true;
						break;
					}
				}
				
				if(isRight==false){
					return false;
				}
			}
			return true;
		}
		
		
		private static function processString(_str:String):String{
			//去除空格,感叹号,逗号,句号,问号
			_str = _str.replace(/([\s]|[\?]|[.]|[!]|[,]|[\;])/g,'');
			_str = _str.toLowerCase();
			return _str;
		}
	}
}