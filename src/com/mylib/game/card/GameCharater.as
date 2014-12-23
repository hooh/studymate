package com.mylib.game.card
{
	import com.mylib.game.charater.logic.FighterControllerMediator;

	public class GameCharater
	{
		public var data:GameCharaterData;
		public var fighter:FighterControllerMediator;
		public var heroAtt:uint;
		
		public function GameCharater(data:GameCharaterData,fighter:FighterControllerMediator)
		{
			this.data = data;
			this.fighter = fighter;
		}
	}
}