package com.mylib.game.card
{
	public class PlayerLevelNpcRawVO
	{
		public var id:String;
		public var levelId:String;
		public var npcId:String;
		
		public function PlayerLevelNpcRawVO(id:String,levelId:String,npcId:String)
		{
			this.id = id;
			this.levelId = levelId;
			this.npcId = npcId;
		}
	}
}