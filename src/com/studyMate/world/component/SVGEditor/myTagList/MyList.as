package com.studyMate.world.component.SVGEditor.myTagList
{
	import flash.events.KeyboardEvent;
	
	import fl.controls.List;
	
	public class MyList extends List
	{
		public function MyList()
		{
			super();
		}
		
		override protected function keyUpHandler(e:KeyboardEvent):void
		{
//			super.keyUpHandler();
		}
		
		override protected function keyDownHandler(event:KeyboardEvent):void {
			// You must override this function if your component accepts focus
		}
		
	}
}