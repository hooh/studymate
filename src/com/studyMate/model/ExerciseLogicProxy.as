package com.studyMate.model
{
	import com.studyMate.model.vo.ExerciseFlowVO;
	import com.studyMate.model.vo.ExerciseVO;
	
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class ExerciseLogicProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "ExerciseLogicProxy";
		
		private var answer:Array=null;
		private var flow:Vector.<ExerciseFlowVO>=null;
		
		private var isFirstTimeWrong:Boolean = false;
		
		private var wrongNum:int=0;
		private var wrongFlow:Vector.<ExerciseFlowVO>;
		private var rightFlow:Vector.<ExerciseFlowVO>;
		
		public function ExerciseLogicProxy( data:ExerciseVO=null)
		{
			super(NAME, data);
		}
		
		public function init(data:Object):void{
			isFirstTimeWrong = false;
			wrongNum=0;
			rightFlow = new Vector.<ExerciseFlowVO>;
			wrongFlow = new Vector.<ExerciseFlowVO>;
			if(data is ExerciseVO){
				answer = data.answer.split("/");
				rightFlow.push(data.flows[0]);
				for(var i:int=1;i<data.flows.length;i++){
					wrongFlow.push(data.flows[i]);
				}
			}
			
		}
		public function getAnswer():Array{
//			if(!answer){
//				return [];
//			}
			return answer;
			
		}
		override public function onRegister():void
		{
			isFirstTimeWrong = false;
			wrongNum=0;
		}
		public function checkAnswer(_str:String):ExerciseFlowVO{
			return _checkAnswer(_str,answer);
		}
		private function processString(_str:String):String{
			_str = _str.replace(/\s+/g,"");//去除空格
			_str = _str.replace(/!+/g,"");//去除感叹号
			_str = _str.replace(/,+/g,"");//去除逗号
			_str = _str.replace(/\.+/g,"");//去除句号
			_str = _str.replace(/\?+/g,"");//去除问号
			_str = _str.toLowerCase();
			return _str;
		}
		private function _checkAnswer(_str:String,answerArr:Array):ExerciseFlowVO{
			if(!answerArr){
				return null;
			}
			/*var r_num:int = 0;
			
			var inputAnswer:Array = _str.split("/");*/

			//用户输入
			var inputStrArr:Array = _str.split("/");
			if(inputStrArr.length==1){
				var inputAnswerStr:String = inputStrArr[0];
			}else if(inputStrArr.length>1){
				inputAnswerStr = inputStrArr[0];
				var inputReasonStr:String = inputStrArr[1];
			}
			inputAnswerStr = processString(inputAnswerStr);
			inputReasonStr = processString(inputReasonStr);
			
			//标准答案
	
			if(answerArr.length==1){
				var _answerStr:String = answerArr[0];
			}else if(answerArr.length>1){
				_answerStr = answerArr[0];
				var _reasonStr:String = answerArr[1];
			}
		
			
			_answerStr = processString(_answerStr);
			_reasonStr = processString(_reasonStr);
			//
			var isAnswerRight:Boolean = match(_answerStr,inputAnswerStr);
			var isReasonRight:Boolean = match2(_reasonStr,inputReasonStr);
			
			if(isAnswerRight&&isReasonRight){
				return new ExerciseFlowVO(answer.join("/"),true,rightFlow[0].tag,[isAnswerRight,isReasonRight]);
			}else{
				//------------------------------------
				//var mediator:QuestionAnswerViewMediator = facade.retrieveMediator(QuestionAnswerViewMediator.NAME) as QuestionAnswerViewMediator;
				//暂时隐藏掉。第一遍错误提示。
				/*if(mediator&&!isFirstTimeWrong){
					isFirstTimeWrong = true;
					var vo:ExerciseFlowVO = new ExerciseFlowVO(answer.join("/"),false,wrongFlow[1].tag,[isAnswerRight,isReasonRight]);
					vo.isFirstTimeWrong = true;
					return vo;
				}*/
				//-----------------------------------------
				if(wrongNum>=wrongFlow.length-1){
					wrongNum=wrongFlow.length-1;
				}
				wrongNum++;
				return new ExerciseFlowVO(answer.join("/"),false,wrongFlow[wrongNum-1].tag,[isAnswerRight,isReasonRight]);
			}
			
			/*for(var i:int=0;i<answerArr.length;i++){
				if(answerArr[i]){
					var isMatch:Boolean = false;
					var tmpArr:Array = String(answerArr[i]).split("&");
					for(var j:int = 0;j<tmpArr.length;j++){
						if(!inputAnswer[i]){
							break;
						}
						var inputStr:String = inputAnswer[i];
						inputStr = inputStr.toLowerCase();
						var answerStr:String = tmpArr[j];
						answerStr = answerStr.toLowerCase();
						answerStr = StringUtil.trim(answerStr);
						if(answerStr==inputStr){
							isMatch = true;
							break;
						}
					}
					if(!isMatch){
						r_num++;
					}
				}
			}
			if(r_num==0){
				return new ExerciseFlowVO(answer.join("/"),true,rightFlow[0].tag);
			}else{
				
				if(wrongNum>=wrongFlow.length-1){
					wrongNum=wrongFlow.length-1;
				}
				wrongNum++;
				return new ExerciseFlowVO(answer.join("/"),false,wrongFlow[wrongNum-1].tag);
			}*/
		}
		private function match(answer:String,inputStr:String):Boolean{
			if(answer.indexOf("&")!=-1){
				if(inputStr.indexOf("&")!=-1){
					if(answer==inputStr){
						return true;
					}
				}else{
					var optionAnswerArr:Array = answer.split("&");
					for(var i:int=0;i<optionAnswerArr.length;i++){
						var tmpStr:String = optionAnswerArr[i];
						tmpStr = StringUtil.trim(tmpStr);
						if(tmpStr==inputStr){
							return true;
						}
					}
				}
				
			}else{
				if(answer==inputStr){
					return true;
				}
			}
			return false;
		}
		//判断理由
		private function match2(answer:String,inputStr:String):Boolean{
			var answerArr:Array = answer.split("&");
			var inputArr:Array = inputStr.split('&');
			for(var i:int=0;i<answerArr.length;i++){
				var answerStr:String = StringUtil.trim(answerArr[i]);
				for(var j:int=0;j<inputArr.length;j++){
					var inputTempStr:String = StringUtil.trim(inputArr[j]);
					if(answerStr==inputTempStr){
						return true;
					}
				}
				
			}
						
			return false;
		}
		
		/*private function match2(answer:String,inputStr:String):Boolean{
			
			var answerArr:Array = answer.split("#");
			var inputArr:Array = inputStr.split("#");
			var isAllMatch:Boolean = false;
			for(var i:int=0;i<answerArr.length;i++){
				var isMatch:Boolean = false;
				if(answerArr[i]){
					if(inputArr[i]&&inputArr[i].indexOf("&")!=-1){
						if(inputArr[i]==answerArr[i]){
							return true;
						}else{
							return false;
						}
					}
					var optionAnswerArr:Array = String(answerArr[i]).split("&");
					for(var j:int=0;j<optionAnswerArr.length;j++){
						var _inputStr:String = inputArr[i];
						var _answerStr:String = optionAnswerArr[j];
						if(_inputStr==_answerStr){
							isMatch = true;
							break;
						}
					}
				}else{
					isMatch = true;
				}
				if(!isMatch){
					isAllMatch = false;
					break;
				}else{
					isAllMatch = true;
				}
			}
			return isAllMatch;
		}*/
		
		public function get exerciseData():ExerciseVO{
			
			return getData() as ExerciseVO;
			
		}
		
	}
}