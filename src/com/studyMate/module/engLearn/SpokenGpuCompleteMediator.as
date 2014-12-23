package com.studyMate.module.engLearn
{
	public class SpokenGpuCompleteMediator extends SpokenNewMediator
	{
		public static const NAME:String = 'SpokenGpuCompleteMediator';
		public function SpokenGpuCompleteMediator(viewComponent:Object=null)
		{
			super(viewComponent);
			super.mediatorName = NAME;
		}
		
		
		
		override public function onRegister():void
		{
//			TOTALTIMES = 0;
			super.onRegister();
			
			view.familyGradeUI.removeFromParent(true);
		}
		
		
	}
}