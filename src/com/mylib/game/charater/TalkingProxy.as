package com.mylib.game.charater
{
	import com.greensock.TweenLite;
	import com.mylib.game.charater.item.SpeakFrame;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.IslanderControllerMediator;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class TalkingProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "TalkingProxy";
		
		private var player1Frame:SpeakFrame;
		private var player2Frame:SpeakFrame;
		
		private var player:IslanderControllerMediator;
		public var npc:IslanderControllerMediator;
		
		public function TalkingProxy(data:Object=null)
		{
			super(NAME, data);
		}
		override public function onRegister():void
		{
			super.onRegister();
			
			player1Frame = new SpeakFrame("HuaKanT");
			player2Frame = new SpeakFrame("HuaKanT");
		}
		
		
		public function talk(player1:IslanderControllerMediator,player2:IslanderControllerMediator):void{
			player = player1;
			npc = player2;
			player1.charater.walk();
			
			var offset:int;
			var faceDir:Boolean;
			if(player1.charater.view.x>player2.charater.view.x){
				offset = 60;
				player2.charater.dirX = 1;
				faceDir = false;
			}else{
				player2.charater.dirX = -1;
				offset = -60;
				faceDir = true;
				
			}
			
			player1.go(player2.charater.view.x+offset,player2.charater.view.y);
		}
		
		public function stopTalking():void{
			if(npc){
				//重设状态
				npc.fsm.changeState(AIState.IDLE);
				npc = null;
			}
		}
		
		
		
		private function say(charater:IHuman,text:String,frame:SpeakFrame):void{
			frame.text = text;
			
			if(!charater){
				frameDisappear(frame);
				return;
			}
			
			charater.say(frame);
			TweenLite.killTweensOf(frame);
			TweenLite.to(frame,8,{onComplete:frameDisappear,onCompleteParams:[frame]});
		}
		private function frameDisappear(frame:SpeakFrame):void{
			frame.removeFromParent();
		}
		
		
		public function playerSay(_player:ICharater,msg:String):void{
			say(_player as IHuman,msg,player1Frame);
		}
		public function npcSay(msg:String):void{
			if(npc)
				say(npc.charater as IHuman,msg,player2Frame);
		}
		
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			
			player1Frame.dispose();
			player2Frame.dispose();
		}
	}
}