package com.studyMate.model.vo
{
	public class QuestionVO
	{
		public var id:int=0;
		public var userAnswer:String=null;
		public var standardAnswer:String = null;
		/**
		 *判断为对则R，错则E 
		 */
		public var myJudge:String = "";
		
		public function QuestionVO(_id:int,_userAnswer:String,_standardAnswer:String,_judge:Boolean)
		{
			this.id = _id;
			this.userAnswer = _userAnswer;
			this.standardAnswer  = _standardAnswer;
			if(_judge){
				myJudge = "R";
			}else{
				myJudge = "E";
			}
		}
	}
}