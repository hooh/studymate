package com.studyMate.world.screens.component.drawGetWord
{
	import fl.controls.Button;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SentenceElement extends Sprite
	{
		public function SentenceElement(boo:Boolean=true)
		{
			var zhu:Button  = new Button();
			zhu.label = "简单句";
			this.addChild(zhu);
			
			var wei:Button  = new Button();
			wei.label = "并列句";
			this.addChild(wei);
			wei.x = 100;
			
			/*var bin:Button  = new Button();
			bin.label = "从句";
			this.addChild(bin);
			bin.x = 200;
			
			var bu:Button  = new Button();
			bu.label = "插入语";
			this.addChild(bu);
			bu.x = 300;
			
			var zhuang:Button  = new Button();
			zhuang.label = "连词";
			this.addChild(zhuang);
			zhuang.x = 400;	*/
			if(boo){
				this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
				this.addEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);	
			}
								
		}
		private function addToStageHandler(event:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,removeElementHandler);
		}
		private function removeFromStageHandler(event:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE,removeFromStageHandler);	
			if(this.stage.hasEventListener(MouseEvent.MOUSE_UP)) this.stage.removeEventListener(MouseEvent.MOUSE_UP,removeElementHandler);
		}
		
	
		private function removeElementHandler(e:MouseEvent):void{
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,removeElementHandler);
			this.parent.removeChild(this);
		}
	}
}