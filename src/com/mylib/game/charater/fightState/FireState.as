package com.mylib.game.charater.fightState
{
	import com.mylib.framework.CoreConst;
	import com.mylib.game.charater.logic.FighterControllerMediator;
	import com.mylib.game.fight.FightHelperMediator;
	import com.studyMate.world.controller.vo.AttackCharaterVO;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;

	public class FireState extends BaseFightState
	{
		public var hurtValue:uint;
		
		public function FireState(lastTime:uint,hurtValue:uint,charaterState:FighterControllerMediator,casterState:FighterControllerMediator,skill:uint)
		{
			super(charaterState,casterState,skill);
			type = FightStateType.FIRE;
			this.lastTime = lastTime;
			this.hurtValue = hurtValue;
		}
		
		override public function tick():void
		{
			charaterState.fighter.hp-=hurtValue;
			
			if(charaterState.fighter.hp<=0){
				Facade.getInstance(CoreConst.CORE).sendNotification(FightHelperMediator.CHARATER_KILLED,new AttackCharaterVO(casterState,charaterState,skill));
			}
			
		}
		
	}
}