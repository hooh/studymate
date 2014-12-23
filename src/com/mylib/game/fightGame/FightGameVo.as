package com.mylib.game.fightGame
{
	public class FightGameVo
	{
		
		public var fid:String;		//战斗id
		
		public var aid:String;
		public var aname:String;
		public var bid:String;
		public var bname:String;
		
		public var ablood:int;	//A本回合血量
		public var bblood:int;	//B本回合血量
		public var alrBlood:int;	//A上回合血量
		public var blrBlood:int;	//B上回合血量
		
		public var fstatus:String;	//战斗状态
		public var round:String;	//回合
		
		//本round A、B点数
		public var apoint1:int;
		public var apoint2:int;
		public var apoint3:int;
		public var bpoint1:int;
		public var bpoint2:int;
		public var bpoint3:int;
		
		//上一round A、B点数
		public var alrPoint1:int;
		public var alrPoint2:int;
		public var alrPoint3:int;
		public var blrPoint1:int;
		public var blrPoint2:int;
		public var blrPoint3:int;
		
		//回合查看状态
		public var astatus:String;
		public var bstatus:String;
		
		
		public function FightGameVo()
		{
		}
	}
}