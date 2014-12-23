package com.mylib.game.fight
{
	import com.greensock.TweenLite;
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.logic.AIState;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.charater.logic.IBoid;
	import com.studyMate.world.controller.vo.AttackCharaterVO;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.geom.Vector3D;
	
	import org.as3commons.logging.api.getLogger;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	
	/**
	 *处理战斗时的数值 
	 * @author HooH
	 * 
	 */	
	public class FightHelperMediator extends Mediator
	{
		public static const NAME:String = "FightHelperMediator";
		public var boids:Vector.<FighterControllerMediator>;
		
		public static const LAUNCH_SKILL:String = NAME + "launchSkill";
		public static const ATTACK_CHARATER_COMPLETE:String = NAME + "AttackCharaterComplete";
		public static const JOIN_BATTLE:String = NAME + "joinBattle";
		public static const LEAVE_BATTLE:String = NAME + "leaveBattle";
		public static const CHARATER_KILLED:String = NAME + "charaterKilled";
		
		
		public function FightHelperMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			boids = new Vector.<FighterControllerMediator>;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var acvo:AttackCharaterVO;
			switch(notification.getName())
			{
				case LAUNCH_SKILL:
				{
					acvo = notification.getBody() as AttackCharaterVO;
					var attackAble:Boolean;
					for (var i:int = 0; i < acvo.attacker.fighter.skills.length; i++) 
					{
						if(acvo.attacker.fighter.skills[i].type==acvo.skill){
							acvo.attacker.fighter.skills[i].launch(acvo);
							attackAble = true;
							break;
						}
					}
					
					if(!attackAble){
						acvo.attacker.fsm.changeState(AIState.IDLE);
					}
					
					
					break;
				}
				case JOIN_BATTLE:{
					if(boids.indexOf(notification.getBody() as FighterControllerMediator)<0){
						boids.push(notification.getBody() as IBoid);
						getLogger(FightHelperMediator).debug((notification.getBody() as Mediator).getMediatorName()+" JOIN_BATTLE");
					}
					break;
				}
				case LEAVE_BATTLE:{
					var ide:int = boids.indexOf(notification.getBody() as FighterControllerMediator);
					getLogger(FightHelperMediator).debug("search "+(notification.getBody() as FighterControllerMediator).getMediatorName());
					if(ide>=0){
						getLogger(FightHelperMediator).debug(boids[ide].getMediatorName()+" LEAVE_BATTLE");
						boids.splice(ide,1);
					}
					
					break;
				}
				case ATTACK_CHARATER_COMPLETE:{
					acvo = notification.getBody() as AttackCharaterVO;
					if(acvo.target.fighter.hp<=0){
						sendNotification(CHARATER_KILLED,acvo);
					}else{
						acvo.target.fightDecision.makeHurtDecision(acvo.attacker,acvo.target);
						acvo.attacker.charater.idle();
						TweenLite.to(acvo.attacker,acvo.attacker.fighter.attackInterval,{onComplete:acvo.attacker.fightDecision.makeFightDecision,onCompleteParams:[acvo.attacker]});
					}
					break;
				}
				case CHARATER_KILLED:{
					acvo = notification.getBody() as AttackCharaterVO;
					acvo.target.fsm.changeState(AIState.DEAD);
					Facade.getInstance(CoreConst.CORE).sendNotification(LEAVE_BATTLE,acvo.target);
					TweenLite.delayedCall(2,Facade.getInstance(CoreConst.CORE).sendNotification,[WorldConst.RECLAIM_CHARATER_FROM_BATTLE,acvo.target]);
					if(acvo.attacker){
						acvo.attacker.target = null;
						acvo.attacker.fsm.changeState(AIState.IDLE);
						getLogger(FightHelperMediator).debug(acvo.attacker.getMediatorName()+" kill"+acvo.target.getMediatorName());
					}
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		
		
		
		
		public function getClosestEnemy(startPoint :Vector3D, myrole :uint = 0, range :Number = 200) :IBoid {
			var candidate:IBoid = null;
			var distance 	:Number = Number.MAX_VALUE;
			var small		:Number = Number.MAX_VALUE;
			
			for (var i :int = 0; i < boids.length; i++) {
				distance = Vector3D.distance(boids[i].getPosition(), startPoint);
				
				if (boids[i].alive&&distance <= range && distance < small && (myrole ==0 || myrole != boids[i].group)) {
					small = distance;
					candidate = boids[i];
				}
			}
			
			return candidate;
		}
		
		public function getMinHPEnemy(myrole:uint = 0):IBoid{
			
			var candidate:IBoid = null;
			var hp:Number = Number.MAX_VALUE;
			var small:Number = Number.MAX_VALUE;
			
			for (var i :int = 0; i < boids.length; i++) {
				hp = boids[i].fighter.hp;
				
				if ((myrole ==0 || myrole != boids[i].group)&&hp<small) {
					small = hp;
					candidate = boids[i];
				}
			}
			
			return candidate;
			
			
			
		}
		
		public function getDangerEnemy(startPoint :Vector3D, myrole :uint = 0) :IBoid {
			
			var candidate:IBoid = null;
			var distance 	:Number = Number.MAX_VALUE;
			var small		:Number = Number.MAX_VALUE;
			
			for (var i :int = 0; i < boids.length; i++) {
				distance = Vector3D.distance(boids[i].getPosition(), startPoint);
				
				if (boids[i].alive&&distance <= boids[i].fighter.attackRange+30 && distance < small && (myrole ==0 || myrole != boids[i].group)) {
					small = distance;
					candidate = boids[i];
				}
			}
			
			return candidate;
			
		}
		
		
		override public function listNotificationInterests():Array
		{
			return [LAUNCH_SKILL,JOIN_BATTLE,LEAVE_BATTLE,ATTACK_CHARATER_COMPLETE,CHARATER_KILLED];
		}
		
	}
}