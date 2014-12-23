package com.studyMate.world.screens
{
	import com.mylib.framework.CoreConst;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	public class LearnWordCardTextField extends TextField
	{
		private var mediator:ScreenBaseMediator;
		
		public function LearnWordCardTextField()
		{
			super();
			this.type = TextFieldType.INPUT;
			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE,reomoveStageHandler);
		}
		
		private function addToStageHandler(e:Event):void{
			mediator = new KeyboardCardMediator(this);
			Facade.getInstance(CoreConst.CORE).registerMediator(mediator);
		}
		
		private function reomoveStageHandler(e:Event):void{
			if(mediator) {
				Facade.getInstance(CoreConst.CORE).removeMediator(mediator.getMediatorName());
				mediator=null;
			}
		}
	}
}