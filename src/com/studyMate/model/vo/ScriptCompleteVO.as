package com.studyMate.model.vo
{
	public class ScriptCompleteVO
	{
		
		
		/**
		 *是否为空队列完成 
		 */		
		public var isEmpty:Boolean;
		
		
		public function ScriptCompleteVO(isEmpty:Boolean =false)
		{
			this.isEmpty = isEmpty;
			
		}
	}
}