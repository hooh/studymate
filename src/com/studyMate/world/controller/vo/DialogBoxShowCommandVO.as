package com.studyMate.world.controller.vo
{
	import starling.display.DisplayObjectContainer;

	public class DialogBoxShowCommandVO
	{
		public var holder:DisplayObjectContainer;
		public var x:int;
		public var y:int;
		public var enterFunction:Function;
		public var enterFunctionParams:*;
		public var cancleFunction:Function;
		public var text:String;
		
		public var styName:String;
		
		public function DialogBoxShowCommandVO(holder:DisplayObjectContainer,x:int,y:int,
											   enterFunction:Function,text:String,cancleFunction:Function=null,
											   enterFunctionParams:*=null,styName:String="style1")
		{
			this.holder = holder;
			this.x = x;
			this.y = y;
			this.enterFunction = enterFunction;
			this.enterFunctionParams = enterFunctionParams;
			this.cancleFunction = cancleFunction;
			this.text = text;
			
			this.styName = styName;
		}
	}
}