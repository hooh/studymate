package com.mylib.game.charater
{
	import com.mylib.game.charater.item.FeelingFrame;
	import com.mylib.game.charater.item.SpeakFrame;
	
	import flash.events.EventDispatcher;
	
	public class TalkPair extends EventDispatcher{
		public var player1:IHuman;
		public var player2:IHuman;
		public var dialogue:Vector.<TalkSection>;
		public var sentenceIdx:int;
		public var behaviorIdx:int;
		public var sectionIdx:int;
		public var frame:SpeakFrame;
		public var feel:FeelingFrame;
		
		public static const END_DIALOGUE_EVENT:String = "endDialogue";
		
		
		public function addPlayer(_p:IHuman):void{
			
			player1?player2=_p:player1=_p;
			
		}
		
		public function TalkPair(font:String=null):void{
			
			if(font){
				frame = new SpeakFrame(font);
			}else{
				frame = new SpeakFrame();
			}
			feel = new FeelingFrame();
			
			
			
		}
		
		public function dispose():void{
			player1 = null;
			player2 = null;
			dialogue = null;
			sentenceIdx = 0;
			behaviorIdx = 0;
			sectionIdx = 0;
		}
		
		public function get isFull():Boolean{
			return player1&&player2;
		}
		
		
	}
}