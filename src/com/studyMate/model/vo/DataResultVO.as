package com.studyMate.model.vo
{
	public final class DataResultVO
	{
		/**
		 *是否结束包 
		 */		
		public var isEnd:Boolean;
		public var isBreak:Boolean;
		public var isErr:Boolean;
		public var type:String;
		public var isCanceled:Boolean;
		
		public var result:Array;
		public var resultCnt:int;
		
		/**
		 *带给上层的参数 
		 */		
		public var para:Array;
		
		public function DataResultVO(isEnd:Boolean=false)
		{
			this.isEnd = isEnd;
		}
	}
}