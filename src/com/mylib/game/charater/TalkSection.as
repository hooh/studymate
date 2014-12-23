package com.mylib.game.charater
{
	public class TalkSection
	{
		
		public var behaviors:Vector.<ActorBehavior>;
		
		public function TalkSection()
		{
			behaviors = new Vector.<ActorBehavior>;
		}
		
		public function addBehavior(_behavior:ActorBehavior):void{
			
			behaviors.push(_behavior);
			
		}
		
		
		
	}
}