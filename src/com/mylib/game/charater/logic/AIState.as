package com.mylib.game.charater.logic
{
	public class AIState
	{
		//战场
		public static const SEEKING:String="seeking";
		public static const TARGETING:String = "targeting";
		public static const FREEZE:String = "freeze";
		public static const FIGHTING:String = "fighting";
		public static const DEAD:String = "dead";
		public static const IDLE:String = "idle";
		public static const DECISION:String = "decision";
		public static const HIT:String = "hit";
		public static const ESCAPE:String = "escape";
		
		//岛民
		public static const SIT:String = "sit";
		public static const REST:String = "rest";
		public static const TALK:String = "talk";
		public static const RANDOM_GO:String = "randomGO";
		public static const FIND_TALK_PARTNER:String = "findTalkPartner";
		
		//宠物狗专有
		public static const WALK:String = "walk";
		public static const RUN:String = "run";
		public static const NORMAL:String = "normal";
		public static const SHOUT:String = "shout";
		public static const BREATHE:String = "breathe";
		public static const NORMALSIDE:String = "normalSide";
		public static const LIEDOWN:String = "liedown";
		
		
		
	}
}