package com.studyMate.module.classroom
{
	public class ExamHistVO
	{
		public var time:String;//回答时间
		public var answer:String;//用户答案
		public var mark:String;//回答标记（R，E）
		
		public function ExamHistVO(arr:Array = null){
			if(arr==null) return;
			time = arr[2];
			time = time.substr(0,4)+'-'+time.substr(4,2)+'-'+time.substr(6,2)+ " "+time.substr(9,2)+':'+time.substr(11,2)+':'+time.substr(13);
			answer =arr[3];
			mark = arr[4];
		}
	}
}