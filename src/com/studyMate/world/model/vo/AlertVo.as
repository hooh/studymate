package com.studyMate.world.model.vo
{
	import flash.display.DisplayObjectContainer;

	public class AlertVo
	{
		public var str:String;//内容
		public var noBtn:Boolean;//取消按钮是否显示
		public var yesHandler:String;//确定事件
		public var noHandler:String;//取消事件
		public var type:uint;
		public var isHTML:Boolean;
		public var yesParameter:*;
		public var yesFun:Function;
		public var noParameter:*;
		public var noFun:Function;
		public var skin:DisplayObjectContainer;
		
		
		public function AlertVo(str:String,
								noBtn:Boolean=true,
								yesHandler:String="yesHandler",
								noHandler:String="noHandler",
								isHTML:Boolean=false,
								yesParameter:* = null,
								yesFun:Function =null,
								noParameter:* = null,
								noFun:Function =null
								)
		{
			this.str = str;
			this.noBtn = noBtn;
			this.yesHandler = yesHandler;
			this.noHandler = noHandler;
			this.isHTML = isHTML;
			this.yesParameter = yesParameter;
			this.yesFun = yesFun;
			this.noParameter = noParameter;
			this.noFun = noFun;
			
			
		}
	}
}