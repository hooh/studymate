package com.studyMate.model.vo
{
	import spark.components.TextArea;

	public final class ScriptVO
	{
		public var script:String;
		public var logDisplayer:TextArea;
		/**
		 *是否自定义的脚本 
		 */		
		public var isMyScript:Boolean;
		
		public function ScriptVO(_script:String,completeNotification:String=null)
		{
			script = _script;
		}
	}
}