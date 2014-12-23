package com.studyMate.model.vo
{
	public class ExerciseFlowVO
	{
		/**
		 *结果对与错 
		 */		
		public var result:Boolean;
		/**
		 *要执行的标签名 
		 */		
		public var tag:String;
		/**
		 *答案 
		 */		
		public var answer:String;
		
		/**
		 *答案和理由答题情况，如[true,true]，[true,false] 等。
		 */
		public var ANR:Array;
		
		/**
		 *第一次输错不算错，之后输错才开始算错 
		 */
		public var isFirstTimeWrong:Boolean = false;
		
		public function ExerciseFlowVO(_answer:String,_result:Boolean,_tag:String,_ANR:Array=null)
		{
			result = _result;
			tag = _tag;
			answer = _answer;
			ANR = _ANR;
		}
	}
}