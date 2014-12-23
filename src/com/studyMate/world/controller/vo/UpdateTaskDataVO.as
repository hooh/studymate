package com.studyMate.world.controller.vo
{
	
	public class UpdateTaskDataVO 
	{
		/**
		 * 任务类型<br>
		 * yy.W 英语单词<br>
		 * yy.R 英语阅读<br>
		 * yy.P 知识点<br>
		 * yy.E 习题<br>
		 */		
		public var type:String = "";
		
		/**
		 * 任务rrl<br>
		 * 如： yy.W.06.016
		 */	
		public var rrl:String = "";
		
		/**
		 * 任务状态 <br>
		 * A:未完成<br>
		 * R:进行中<br>
		 * Z:已完成<br>
		 */		
		public var statu:String = "";
		
		/**
		 * 任务分数 
		 */		
		public var level:String = "";
		
		public function UpdateTaskDataVO(type:String,rrl:String,statu:String,level:String)
		{
			this.type = type;
			this.rrl = rrl;
			this.statu = statu;
			this.level = level;
			
			
		}
	}
}