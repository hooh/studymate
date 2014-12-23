package com.studyMate.model.vo
{
	public class ActionVO
	{
		public var obj:*;
		public var fun:Function;
		public var params:Array;
		public var priority:int;
		
		public function ActionVO(obj:*,fun:Function,params:Array,priority:int=0):void{
			this.obj = obj;
			this.fun = fun;
			this.params = params;
			this.priority = priority;
		}
		
		
	}
}