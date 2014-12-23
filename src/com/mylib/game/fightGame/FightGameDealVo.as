package com.mylib.game.fightGame
{
	import com.studyMate.model.vo.tcp.PackData;

	public class FightGameDealVo
	{
		
		public var fid:String;		//战斗id
		
		public var myId:String;
		public var myName:String;
		public var yourId:String;
		public var yourName:String;
		
		public var myBlood:int;	//A本回合血量
		public var yourBlood:int;	//B本回合血量
		public var myLrBlood:int;	//A上回合血量
		public var yourLrBlood:int;	//B上回合血量
		
		public var fstatus:String;	//战斗状态
		public var round:String;	//回合
		
		//本round A、B点数
		public var myPoint1:int;
		public var myPoint2:int;
		public var myPoint3:int;
		public var yourPoint1:int;
		public var yourPoint2:int;
		public var yourPoint3:int;
		
		//上一round A、B点数
		public var myLrPoint1:int;
		public var myLrPoint2:int;
		public var myLrPoint3:int;
		public var yourLrPoint1:int;
		public var yourLrPoint2:int;
		public var yourLrPoint3:int;
		
		//回合查看状态
		public var myStatus:String;
		public var yourStatus:String;
		
		public var isAsk:Boolean = false;
		
		public function FightGameDealVo(_vo:FightGameVo)
		{
			fid = _vo.fid;
			fstatus = _vo.fstatus;
			round = _vo.round;
			
			//主动挑战
			if(_vo.aid == PackData.app.head.dwOperID.toString()){
				isAsk = true;
				
				myId = _vo.aid;
				myName = _vo.aname;
				yourId = _vo.bid;
				yourName = _vo.bname;
				
				myBlood = _vo.ablood;
				yourBlood = _vo.bblood;
				myLrBlood = _vo.alrBlood;
				yourLrBlood = _vo.blrBlood;
				
				
				myPoint1 = _vo.apoint1;
				myPoint2 = _vo.apoint2;
				myPoint3 = _vo.apoint3;
				yourPoint1 = _vo.bpoint1;
				yourPoint2 = _vo.bpoint2;
				yourPoint3 = _vo.bpoint3;
				
				myLrPoint1 = _vo.alrPoint1;
				myLrPoint2 = _vo.alrPoint2;
				myLrPoint3 = _vo.alrPoint3;
				yourLrPoint1 = _vo.blrPoint1;
				yourLrPoint2 = _vo.blrPoint2;
				yourLrPoint3 = _vo.blrPoint3;
				
				myStatus = _vo.astatus;
				yourStatus = _vo.bstatus;
				
			}else{
				isAsk = false;
				
				myId = _vo.bid;
				myName = _vo.bname;
				yourId = _vo.aid;
				yourName = _vo.aname;
				
				myBlood = _vo.bblood;
				yourBlood = _vo.ablood;
				myLrBlood = _vo.blrBlood;
				yourLrBlood = _vo.alrBlood;
				
				
				myPoint1 = _vo.bpoint1;
				myPoint2 = _vo.bpoint2;
				myPoint3 = _vo.bpoint3;
				yourPoint1 = _vo.apoint1;
				yourPoint2 = _vo.apoint2;
				yourPoint3 = _vo.apoint3;
				
				myLrPoint1 = _vo.blrPoint1;
				myLrPoint2 = _vo.blrPoint2;
				myLrPoint3 = _vo.blrPoint3;
				yourLrPoint1 = _vo.alrPoint1;
				yourLrPoint2 = _vo.alrPoint2;
				yourLrPoint3 = _vo.alrPoint3;
				
				myStatus = _vo.bstatus;
				yourStatus = _vo.astatus;
				
				
			}
			
			
			
			
			
			
		}
	}
}