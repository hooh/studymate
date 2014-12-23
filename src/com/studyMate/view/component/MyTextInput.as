package com.studyMate.view.component
{
	import com.mylib.framework.CoreConst;
	
	import flash.events.Event;
	
	import spark.components.TextInput;
	
	import spark.skins.mobile.TextInputSkin;
	
	public class MyTextInput extends TextInput
	{
		
		private var mediator:MyTextInputMediator;
		
		public function MyTextInput()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE,textinput1_addedToStageHandler);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,textinput1_removedFromStageHandler);
			
			this.setStyle("skinClass",Class(spark.skins.mobile.TextInputSkin));
			//trace("添加组件");
			
		}
		
		protected function textinput1_addedToStageHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			mediator = new MyTextInputMediator(this);
			Facade.getInstance(CoreConst.CORE).registerMediator(mediator);
		}
		
		protected function textinput1_removedFromStageHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			Facade.getInstance(CoreConst.CORE).removeMediator(mediator.getMediatorName());
			mediator = null;
		}
		
		
	}
}