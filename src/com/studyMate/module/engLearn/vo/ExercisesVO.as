package com.studyMate.module.engLearn.vo
{
	import mx.utils.StringUtil;

	public class ExercisesVO
	{
		public var id:String;
		
		public var topickind:String;		//题型   T填空题  ， X选择题
		public var question:String;			//题目
		public var items:Array;				//选项
		public var answer:String;			//答案		
		public var reason:String;			//理由
		public var help_1:String;			//一错提示
		public var help_2:String;			//二错提示
		public var detail:String;			//详解
		
		
		public var isChecked:Boolean;	//是否做过
		public var userAnswer:String = '';//用户输入答案
		public var ROE:String;//对则R，错则E  
		
		public function ExercisesVO(jsonStr:String)
		{
			var result:Object = JSON.parse(jsonStr);
			
			topickind = result.topickind;
			question = StringUtil.trim(result.question);
			items = result.items;
			answer = result.answer;
			reason = result.reason;
			help_1 = result.help.replace(/\r/g,'');
			help_2 = result.hint.replace(/\r/g,'');
			detail = result.detail.replace(/\r/g,'');
//			trace(jsonStr);
		}
	}
}