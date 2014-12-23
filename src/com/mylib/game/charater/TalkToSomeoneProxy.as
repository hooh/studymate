package com.mylib.game.charater
{
	import com.greensock.TweenLite;
	import com.mylib.game.charater.item.SpeakFrame;
	import com.studyMate.world.controller.vo.LetCharaterWalkToCommandVO;
	import com.studyMate.world.screens.WorldConst;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class TalkToSomeoneProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "TalkToSomeoneProxy";
		
		private var player1Frame:SpeakFrame;
		private var player2Frame:SpeakFrame;
		
		private var player:ICharater;
		
		public var npc:ICharater;
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
			player1Frame = new SpeakFrame("HuaKanT");
			player2Frame = new SpeakFrame("HuaKanT");
		}
		
		override public function onRemove():void
		{
			// TODO Auto Generated method stub
			super.onRemove();
			
			player1Frame.dispose();
			player2Frame.dispose();
			
		}
		
		
		public function TalkToSomeoneProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function talk(player1:ICharater,player2:ICharater):void{
			player = player1;
			npc = player2;
			player1.walk();
			
			var offset:int;
			var faceDir:Boolean;
			if(player1.view.x>player2.view.x){
				offset = 60;
				player2.dirX = 1;
				faceDir = false;
			}else{
				player2.dirX = -1;
				offset = -60;
				faceDir = true;
				
			}
			
			
			sendNotification(WorldConst.LET_CHARATER_WALK_TO,new LetCharaterWalkToCommandVO(player1,player2.view.x+offset,player2.view.y,1,playerWalkComplete,[player1,faceDir]));
			
			
		}
		
		public function stopTalking():void{
			if(npc){
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
		
		public function playerSay(msg:String):void{
			say(player as IHuman,msg,player1Frame);

		}
		public function playerSay2(_player:ICharater,msg:String):void{
			say(_player as IHuman,msg,player1Frame);
		}
		
		private function frameDisappear(frame:SpeakFrame):void{
			frame.removeFromParent();
		}
		
		public function npcSay(msg:String):void{
			say(npc as IHuman,msg,player2Frame);
		}
		
		private function playerWalkComplete(charater:ICharater,dir:Boolean):void{
			
			charater.idle();
			
			if(dir){
				charater.dirX=1;
			}else{
				charater.dirX=-1;
			}
			
			
			
		}
		
		
	}
}