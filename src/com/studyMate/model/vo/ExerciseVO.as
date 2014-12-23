package com.studyMate.model.vo
{
	public class ExerciseVO
	{
		public var answer:String;
		public var flows:Vector.<ExerciseFlowVO>;
		public function ExerciseVO(answer:String,flows:Vector.<ExerciseFlowVO>)
		{
			this.answer = answer;
			this.flows = flows;
		}
	}
}