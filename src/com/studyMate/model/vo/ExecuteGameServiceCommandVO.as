package com.studyMate.model.vo
{
	public class ExecuteGameServiceCommandVO
	{
		public var commands:String;
		public var operation:String;
		public function ExecuteGameServiceCommandVO(commands:String,operation:String)
		{
			this.commands = commands;
			this.operation = operation;
		}
	}
}