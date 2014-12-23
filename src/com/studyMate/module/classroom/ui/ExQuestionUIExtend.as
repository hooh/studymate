package com.studyMate.module.classroom.ui
{
	import com.studyMate.module.engLearn.ui.ExamQuestionUI;
	
	import flash.text.TextFormat;

	public class ExQuestionUIExtend extends ExamQuestionUI
	{
		
		
		public function ExQuestionUIExtend(title:String, option:Array)
		{
			super(title, option);
			tf = new TextFormat("HeiTi",26,0x471100,true);
			tf1 = new TextFormat("HeiTi",26,0x471100,true);
			maxWidth = 642;
			left = 20;			
			top = 100;
			scrollHeight = 490;
			maxHeight = 674;
		}
		
		override protected function get viewClass():Class
		{
			return super.viewClass;
		}
		
	}
}