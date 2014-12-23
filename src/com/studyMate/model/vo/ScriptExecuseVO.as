package com.studyMate.model.vo
{
	public final class ScriptExecuseVO
	{
		public var pageNo:*;
		public var line:int;
		public var jump:Boolean;
		public var doInit:Boolean;
		
		/**
		 * 
		 * @param pageNo 页码 数字或字符串 如果为数字则认为是<page+pageNo> 开头
		 * @param line  执行多少行 默认-1执行全部
		 * @param jump 是否跳过过渡
		 * @param doInit 是否执行页面初始化
		 */		
		public function ScriptExecuseVO(pageNo:*,line:int=-1,jump:Boolean=false,doInit:Boolean=true)
		{
			this.pageNo = pageNo;
			this.line = line;
			this.jump = jump;
			this.doInit = doInit;
		}
	}
}