package com.studyMate.world.model.vo
{
	public class GameTaskVO
	{
		public var id:String;
		public var name:String;
		public var description:String;
		public var type:String;
		public var script:String;
		public var playerNumber:int;
		public var time:int;
		public var reward:int;
		public var isMainLine:String;
		public var orderNum:int;
		public var islandIDs:String;
		public var cd:int;
		
		public function GameTaskVO()
		{
		}
		
		public function clone():GameTaskVO{
			var result:GameTaskVO =  new GameTaskVO();
			result.id = id;
			result.name = name;
			result.description = description;
			result.type = type;
			result.script = script;
			result.playerNumber = playerNumber;
			result.time = time;
			result.reward = reward;
			result.isMainLine = isMainLine;
			result.orderNum = orderNum;
			result.islandIDs = islandIDs;
			result.cd = cd;
			return result;
		}
		
	}
}