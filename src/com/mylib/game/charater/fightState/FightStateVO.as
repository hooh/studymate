package com.mylib.game.charater.fightState
{
	import com.mylib.game.charater.logic.FighterControllerMediator;

	public class FightStateVO
	{
		public var fightState:IFightState;
		public var charaterState:FighterControllerMediator;
		
		public function FightStateVO(fightState:IFightState,charaterState:FighterControllerMediator)
		{
			this.fightState = fightState;
			this.charaterState = charaterState;
		}
	}
}