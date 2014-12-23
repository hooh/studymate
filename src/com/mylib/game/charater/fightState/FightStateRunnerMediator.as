package com.mylib.game.charater.fightState
{
	import com.mylib.game.charater.HumanMediator;
	import com.mylib.game.charater.IFighter;
	import com.mylib.game.charater.logic.RunnerMediator;
	import com.mylib.game.fight.FightHelperMediator;
	import com.studyMate.world.screens.WorldConst;
	
	import flash.utils.getTimer;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	public class FightStateRunnerMediator extends RunnerMediator
	{
		public static const NAME:String = "FightStateRunnerMediator";
		private var fightHelper:FightHelperMediator;
		private var count:Number;
		
		public function FightStateRunnerMediator()
		{
			super(NAME, viewComponent);
		}
		
		
		override public function onRegister():void
		{
			fightHelper = facade.retrieveMediator(FightHelperMediator.NAME) as FightHelperMediator;
			count = 0;
			start();
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
		}
		
		
		
		
		
		override public function advanceTime(time:Number):void
		{
			count += time;
			
			if(count>1){
				count = 0;
				var c:IFighter;
				var state:IFightState;
				for (var i:int = 0; i < fightHelper.boids.length; i++) 
				{
					c = fightHelper.boids[i].fighter;
					for (var j:int = 0; j < c.fightStates.length; j++) 
					{
						state = c.fightStates[j];
						
						
						state.tick();
						if(state.enterTime+state.lastTime<=getTimer()){
							removeFightState(state);
						}
						
						
					}
				}
				
			}
			
			
		}
		
		public function removeFightState(state:IFightState):void{
			
			var idx:int = state.charaterState.fighter.fightStates.indexOf(state);
			
			if(idx>=0){
				sendNotification(WorldConst.CHARATER_STATE_REMOVED,state);
				state.charaterState.fighter.fightStates.splice(idx,1);
			}
			
			
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case WorldConst.ADD_FIGHT_STATE:
				{
					var fightStateVO:FightStateVO = notification.getBody() as FightStateVO;
					var exist:Boolean;
					for (var i:int = 0; i < fightStateVO.charaterState.fighter.fightStates.length; i++) 
					{
						if(fightStateVO.charaterState.fighter.fightStates[i].type==fightStateVO.fightState.type){
							exist = true;
							break;
						}
					}
					
					if(!exist){
						fightStateVO.charaterState.fighter.addState(fightStateVO.fightState);
						fightStateVO.fightState.charaterState = fightStateVO.charaterState;
						fightStateVO.fightState.enter();
					}
					
					
					
					
					break;
				}
				case WorldConst.REMOVE_FIGHT_STATE:{
					removeFightState(notification.getBody() as IFightState);
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [WorldConst.ADD_FIGHT_STATE,WorldConst.REMOVE_FIGHT_STATE];
		}
		
	}
}