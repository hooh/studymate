package com.studyMate.model.vo
{
	public class UpdateGameServiceCommandVO
	{
		public var gameList:String;
		public var time:int;
		public var operation:String;
		public function UpdateGameServiceCommandVO(gameList:String,time:int,operation:String)
		{
			this.gameList = gameList;
			this.time = time;
			this.operation = operation;
		}
	}
}