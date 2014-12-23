package com.mylib.game.controller
{
	import com.mylib.game.card.CardPlayerDisplay;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.IBoid;
	import com.mylib.game.charater.logic.ai.CardFightAI;
	import com.mylib.game.controller.vo.CardFightAnimationVO;
	
	import flash.geom.Vector3D;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class CardFightHelperMediator extends Mediator
	{
		public static const NAME:String = "CardFightAnimationMediator";
		public static const ANIMATE:String = NAME + "animate";
		public static const REGISTER:String = NAME + "regist";
		public var charaters:Vector.<FighterControllerMediator>;
		
		public function CardFightHelperMediator(name:String,viewComponent:Object=null)
		{
			super(name, viewComponent);
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			charaters = new Vector.<FighterControllerMediator>;
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ANIMATE:
				{
					var vo:CardFightAnimationVO = notification.getBody() as CardFightAnimationVO;
					
					for (var i:int = 0; i < vo.attackers.displays.length; i++) 
					{
						var attacker:CardPlayerDisplay = vo.attackers.displays[i];
						attacker.islander.decision = new CardFightAI(attacker.islander.decision,attacker.islander.charater.view.x
						,attacker.islander.charater.view.y,attacker.islander.charater.dirX
						);
						attacker.islander.target = vo.defenders.displays[int(vo.defenders.displays.length*Math.random())].islander;
					}
					
					
					break;
				}
				case REGISTER:{
					charaters.push(notification.getBody() as FighterControllerMediator);
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		
		private function straightFight(attacker:FighterControllerMediator,defender:FighterControllerMediator):void{
			attacker.go(defender.charater.view.x,defender.charater.view.y);
		}
		
		public function reset():void{
			charaters.length=0;
		}
		
		
		public function getRandomEnemy(myrole :uint = 0) :IBoid {
			var candidate:IBoid = null;
			
			var idx:int;
			var i:int=0;
			var len:int = charaters.length;
			while(i<2&&!candidate){
				
				idx = Math.random()*len;
				
				if ((myrole ==0 || myrole != charaters[idx].group)) {
					candidate = charaters[idx];
				}
				
				i++;
			}
			
			return candidate;
		}
		
		
		override public function listNotificationInterests():Array
		{
			return [ANIMATE,REGISTER];
		}
		
	}
}